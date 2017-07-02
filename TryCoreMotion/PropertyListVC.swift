//
//  PropertyListVC.swift
//  TryCoreMotion
//
//  Created by Tatsuya Tanaka on 20170701.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit
import CoreMotion

struct PropertyList {
    var sections: [(title: String, rows: [TableViewCellPropertyType])]
}

class PropertyListVC: UITableViewController {

    fileprivate let motionManager = CMMotionManager()
    fileprivate var recoder: CMSensorRecorder?

    fileprivate let pedometer = CMPedometer()
    fileprivate var pedometerData: CMPedometerData?
    fileprivate var pedometerEvent: CMPedometerEvent?

    fileprivate let altimeter = CMAltimeter()
    fileprivate var altitudeData: CMAltitudeData?

    fileprivate let motionActivityManager = CMMotionActivityManager()
    fileprivate var motionActivity: CMMotionActivity?

    fileprivate var timer: Timer?

    fileprivate lazy var propertyList: PropertyList = { [unowned self] in
        unowned var manager: CMMotionManager = self.motionManager
        var recoder: CMSensorRecorder? = self.recoder
        unowned var pedometer: CMPedometer = self.pedometer
        unowned var altimeter: CMAltimeter = self.altimeter

        return PropertyList(sections:
            [
                (
                    "Determining the Availability of Services",
                    [
                        Property("isDeviceMotionAvailable") { manager.isDeviceMotionAvailable },
                        Property("isAccelerometerAvailable") { manager.isAccelerometerAvailable },
                        Property("isGyroAvailable") { manager.isGyroAvailable },
                        Property("isMagnetometerAvailable") { manager.isMagnetometerAvailable }
                    ]
                ),
                (
                    "Determining Which Services Are Active",
                    [
                        Property("isDeviceMotionActive") { manager.isDeviceMotionActive },
                        Property("isAccelerometerActive") { manager.isAccelerometerActive },
                        Property("isGyroActive") { manager.isGyroActive },
                        Property("isMagnetometerActive") { manager.isMagnetometerActive }
                    ]
                ),
                (
                    "Managing Device Motion Updates",
                    [
                        Property("showsDeviceMovementDisplay") { manager.showsDeviceMovementDisplay },
                        Property("deviceMotionUpdateInterval") { manager.deviceMotionUpdateInterval },
                        Property("deviceMotion") { "" },
                        Property("attitude", indent: 1) { "" },
                        Property("rotationRate", indent: 2) { manager.deviceMotion?.attitude },
                        Property("rotationRate", indent: 1) { manager.deviceMotion?.rotationRate },
                        Property("gravity", indent: 1) { manager.deviceMotion?.gravity },
                        Property("userAcceleration", indent: 1) { manager.deviceMotion?.userAcceleration },
                        Property("magneticField", indent: 1) { "" },
                        Property("field", indent: 2) { manager.deviceMotion?.magneticField.field },
                        Property("accuracy", indent: 2) { manager.deviceMotion?.magneticField.accuracy }
                    ]
                ),
                (
                    "Managing Accelerometer Updates",
                    [
                        Property("accelerometerUpdateInterval") { manager.accelerometerUpdateInterval },
                        Property("accelerometerData") { "" },
                        Property("acceleration", indent: 1) { manager.accelerometerData?.acceleration }
                    ]
                ),
                (
                    "Managing Gyroscope Updates",
                    [
                        Property("gyroUpdateInterval") { manager.gyroUpdateInterval },
                        Property("gyroData") { "" },
                        Property("rotationRate", indent: 1) { manager.gyroData?.rotationRate }

                    ]
                ),
                (
                    "Managing Magnetometer Updates",
                    [
                        Property("magnetometerUpdateInterval") { manager.magnetometerUpdateInterval },
                        Property("magnetometerData") { "" },
                        Property("magneticField", indent: 1) { manager.magnetometerData?.magneticField }

                    ]
                ),
                (
                    "Accessing Attitude Reference Frames",
                    [
                        Property("attitudeReferenceFrame") { manager.attitudeReferenceFrame },
                        Property("availableAttitudeReferenceFrames") { "" },
                        Property("xArbitraryZVertical", indent: 1) { CMMotionManager.availableAttitudeReferenceFrames().contains(.xArbitraryZVertical) },
                        Property("xArbitraryCorrectedZVertical", indent: 1) { CMMotionManager.availableAttitudeReferenceFrames().contains(.xArbitraryCorrectedZVertical) },
                        Property("xMagneticNorthZVertical", indent: 1) { CMMotionManager.availableAttitudeReferenceFrames().contains(.xMagneticNorthZVertical) },
                        Property("xTrueNorthZVertical", indent: 1) { CMMotionManager.availableAttitudeReferenceFrames().contains(.xTrueNorthZVertical) }
                    ]
                ),
                (
                    "Accelerometers", { () -> [TableViewCellPropertyType] in
                        guard let logs = recoder?.accelerometerData(from: Date().addingTimeInterval(-60), to: Date()) else { return [] }
                        return logs.map { data -> [TableViewCellPropertyType] in
                            let log = data as! CMRecordedAccelerometerData
                            return [
                                Property("startDate", indent: 1) { log.startDate },
                                Property("identifier", indent: 1) { log.identifier },
                                Property("acceleration", indent: 1) { log.acceleration }
                            ]
                        }.flatMap { $0 }
                    }()
                ),
                (
                    "Pedometer",
                    [
                        Property("isStepCountingAvailable") { CMPedometer.isStepCountingAvailable() },
                        Property("isDistanceAvailable") { CMPedometer.isDistanceAvailable() },
                        Property("isFloorCountingAvailable") { CMPedometer.isFloorCountingAvailable() },
                        Property("isPaceAvailable") { CMPedometer.isPaceAvailable() },
                        Property("isCadenceAvailable") { CMPedometer.isCadenceAvailable() },
                        Property("isPedometerEventTrackingAvailable") { CMPedometer.isPedometerEventTrackingAvailable() },
                        Property("CMPedometerData") { "" },
                        Property("startDate", indent: 1) { self.pedometerData?.startDate },
                        Property("endDate", indent: 1) { self.pedometerData?.endDate },
                        Property("numberOfSteps", indent: 1) { self.pedometerData?.numberOfSteps },
                        Property("distance", indent: 1) { self.pedometerData?.distance },
                        Property("averageActivePace", indent: 1) { self.pedometerData?.averageActivePace },
                        Property("currentPace", indent: 1) { self.pedometerData?.currentPace },
                        Property("currentCadence", indent: 1) { self.pedometerData?.currentCadence },
                        Property("floorsAscended", indent: 1) { self.pedometerData?.floorsAscended },
                        Property("floorsDescended", indent: 1) { self.pedometerData?.floorsDescended },
                        Property("CMPedometerEvent") { "" },
                        Property("date", indent: 1) { self.pedometerEvent?.date },
                        Property("type", indent: 1) { self.pedometerEvent?.type }
                    ] as [TableViewCellPropertyType] // supports the type inference
                ),
                (
                    "Altitude",
                    [
                        Property("isRelativeAltitudeAvailable") { CMAltimeter.isRelativeAltitudeAvailable() },
                        Property("CMAltitudeData") { "" },
                        Property("relativeAltitude", indent: 1) { self.altitudeData?.relativeAltitude },
                        Property("pressure", indent: 1) { self.altitudeData?.pressure }
                    ]
                ),
                (
                    "Historical Data",
                    [
                        Property("isActivityAvailable") { CMMotionActivityManager.isActivityAvailable() },
                        Property("CMMotionActivity") { "" },
                        Property("stationary", indent: 1) { self.motionActivity?.stationary },
                        Property("walking", indent: 1) { self.motionActivity?.walking },
                        Property("running", indent: 1) { self.motionActivity?.running },
                        Property("automotive", indent: 1) { self.motionActivity?.automotive },
                        Property("cycling", indent: 1) { self.motionActivity?.cycling },
                        Property("unknown", indent: 1) { self.motionActivity?.unknown },
                        Property("startDate", indent: 1) { self.motionActivity?.startDate },
                        Property("confidence", indent: 1) { self.motionActivity?.confidence }
                    ]
                )

            ]
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if CMSensorRecorder.isAccelerometerRecordingAvailable() {
            recoder = CMSensorRecorder()
            recoder?.recordAccelerometer(forDuration: 60 * 20) // 20min
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()

        pedometer.startUpdates(from: Date().addingTimeInterval(-60*60*24)) { data, _ in
            self.pedometerData = data
        }
        pedometer.startEventUpdates { event, _ in
            self.pedometerEvent = event
        }

        altimeter.startRelativeAltitudeUpdates(to: OperationQueue()) { data, _ in
            self.altitudeData = data
        }

        motionActivityManager.startActivityUpdates(to: OperationQueue()) { activity in
            self.motionActivity = activity
        }

        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [unowned self] _ in
            self.tableView.reloadData()
        }
        RunLoop.main.add(timer, forMode: .commonModes)
        self.timer = timer
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
        altimeter.stopRelativeAltitudeUpdates()
        motionActivityManager.stopActivityUpdates()
    }
}

extension PropertyListVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return propertyList.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyList.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return propertyList.sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let property = propertyList.sections[indexPath.section].rows[indexPath.row]

        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = property.name
        cell.detailTextLabel?.text = property.stringValue
        cell.indentationLevel = property.indentationLevel
        return cell
    }
}

//
//  KeyValueType.swift
//  TryCoreMotion
//
//  Created by Tatsuya Tanaka on 20170701.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation
import CoreMotion

protocol PropertyValue {
    var stringValue: String { get }
}

protocol DetailPropertyValue: PropertyValue {}
extension DetailPropertyValue {
    var stringValue: String { return "Detail" }
}

extension Bool: PropertyValue {
    var stringValue: String { return "\(self)" }
}

extension String: PropertyValue {
    var stringValue: String { return "\(self)" }
}

extension UInt64: PropertyValue {
    var stringValue: String { return "\(self)" }
}

extension NSNumber: PropertyValue {
}

extension Double: PropertyValue {
    var stringValue: String { return "\(self)" }
}

extension Date: PropertyValue {
    var stringValue: String { return "\(self)" }
}

extension CMAttitude: PropertyValue {
    var stringValue: String { return String(format: "roll: %.3f, pitch: %.3f, yaw: %.3f", roll, pitch, yaw) }
}

extension CMRotationRate: PropertyValue {
    var stringValue: String { return String(format: "x: %.3f, y: %.3f, z: %.3f", x, y, z) }
}

extension CMAcceleration : PropertyValue {
    var stringValue: String { return String(format: "x: %.3f, y: %.3f, z: %.3f", x, y, z) }
}

extension CMMagneticField : PropertyValue {
    var stringValue: String { return String(format: "x: %.3f, y: %.3f, z: %.3f", x, y, z) }
}

extension CMMagneticFieldCalibrationAccuracy: PropertyValue {
    var stringValue: String {
        switch self {
        case .uncalibrated: return "uncalibrated"
        case .low: return "low"
        case .medium: return "medium"
        case .high: return "high"
        }
    }
}

extension CMCalibratedMagneticField: PropertyValue {
    var stringValue: String { return "field: \(field.stringValue), accuracy: \(accuracy.stringValue)" }
}

extension CMAttitudeReferenceFrame: PropertyValue {
    var stringValue: String {
        switch self {
        case CMAttitudeReferenceFrame.xArbitraryZVertical: return "xArbitraryZVertical"
        case CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical: return "xArbitraryCorrectedZVertical"
        case CMAttitudeReferenceFrame.xMagneticNorthZVertical: return "xMagneticNorthZVertical"
        case CMAttitudeReferenceFrame.xTrueNorthZVertical: return "xTrueNorthZVertical"
        default: return ""
        }
    }
}

extension CMPedometerEventType: PropertyValue {
    var stringValue: String {
        switch self {
        case .pause: return "pause"
        case .resume: return "resume"
        }
    }
}

extension CMMotionActivityConfidence: PropertyValue {
    var stringValue: String {
        switch self {
        case .high: return "high"
        case .low: return "low"
        case .medium: return "medium"
        }
    }
}

extension Array: DetailPropertyValue {}

protocol PropertyType {
    associatedtype Value
    var name: String { get }
    var value: Value { get }
}

protocol TableViewCellPropertyType: PropertyValue {
    var name: String { get }
    var stringValue: String { get }
    var indentationLevel: Int { get }
}

final class Property<T: PropertyValue>: PropertyType, TableViewCellPropertyType {
    let name: String
    let value: () -> T?

    var stringValue: String { return value()?.stringValue ?? "" }
    let indentationLevel: Int

    init(_ name: String, indent: Int = 0, value: @escaping () -> T?) {
        self.name = name
        self.value = value
        self.indentationLevel = indent
    }
}

//
//  Utility.swift
//  TryCoreMotion
//
//  Created by Tatsuya Tanaka on 20170703.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation
import CoreMotion

extension CMSensorDataList: Sequence {
    public func makeIterator() -> NSFastEnumerationIterator {
        return NSFastEnumerationIterator(self)
    }
}

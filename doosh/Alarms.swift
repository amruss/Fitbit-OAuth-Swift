//
//  Alarms.swift
//  FitAlarm Helper
//
//  Created by Abigail Russell on 1/29/16.
//  Copyright © 2016 Abigail Russell. All rights reserved.
//

import Foundation

class Alarms {
    var alarmID: Int
    var enabled: Bool
    var recurring: Bool
    var time: String
    var weekDays: [String]
    
    
    init(alarmID: Int, enabled: Bool, recurring: Bool, time: String, weekDays: [String]) {
        self.alarmID = alarmID
        self.enabled = enabled
        self.recurring = recurring
        self.time = time
        self.weekDays = weekDays
        
    }
}

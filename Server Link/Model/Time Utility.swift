//
//  Time Utility.swift
//  Server Link
//
//  Created by Warren Hansen on 10/17/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

class TimeUtility {
    
    let now = Date()
    
    func timerDuration(Seconds: Int , timerComplete: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(Seconds)) {
            print("timer complete \(self.now)")
            timerComplete(true)
        }
    }
    
    func isMarketHours(begin: [Int], end: [Int] ) -> Bool  {
        var isMakretHours: Bool
        let calendar = Calendar.current
        
        let start_today = calendar.date(
            bySettingHour: begin[0],
            minute: begin[1],
            second: 0,
            of: now)!
        
        let end_today = calendar.date(
            bySettingHour: end[0],
            minute: end[1],
            second: 0,
            of: now)!
        
        if (now >= start_today && now <= end_today ) {
            print("The time is between \(begin[0]):\(begin[1]) and \(end[0]):\(end[1])")
            isMakretHours = true
        } else {
            print("The time is outside of \(begin[0]):\(begin[1]) and \(end[0]):\(end[1])")
            isMakretHours = false
        }
        return isMakretHours
    }
}


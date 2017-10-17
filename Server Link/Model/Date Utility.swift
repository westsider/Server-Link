//
//  Date Utility.swift
//  Server Link
//
//  Created by Warren Hansen on 10/17/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

class DateHelper {
    
    func convertToDateFrom(string: String)-> Date {
        
        let dateS    = string
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date:Date = formatter.date(from: dateS)!
        return date
    }
    
    func convertToStringFrom(date: Date)-> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: date)
    }
    
    let formatter = DateFormatter()
    let today = Date()
    
    // convert UTC to local
    func convertUTCtoLocal(debug: Bool, UTC: Date)-> Date {
        
        if ( debug ) { print("convertUTCtoLocal\nUTC:       \(today)") }
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let todayString = formatter.string(from: Date())
        if ( debug ) { print("Local str: \(todayString)") }
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let local = formatter.date(from: todayString)
        if ( debug ) { print("local date \(local!)") }
        return local!
    }
    
    // problem area --------------------------------------------------------------------
    // may fail to work in other time zones
    func convertServeDateToLocal( server: Date, debug: Bool)-> ( Date, String, String) {
        
        // this is to return Date
        if ( debug ) { print("\n\n------------    Convert Server Date To Local Date   -----------------------v") }
        if ( debug ) { print("1. EST Date from Server: \(server)   <---+") }
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let serverString = formatter.string(from: server)
        if ( debug ) { print("2. EST str  from server: \(serverString)      <---- These 2 match and are correct!!") }
        //if ( debug ) { print( "These 2 match and are correct!!") }
        
        // calc local equivilant of server time stamp
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let serverDate = formatter.date(from: serverString)
        if ( debug ) { print("3. Date from server str: \(serverDate!)     @ 10:30 +2 and correct @ 11:00 +1 and corrrect, 12:00 + 1 not correct 11AM +0 correct 12:30 +0 correct") }
        
        // calc local equivilant of server hour:min stamp
        formatter.dateFormat = "HH:mm a"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let serverTImeOnlyString = formatter.string(from: serverDate!)
        if ( debug ) { print("4. Local time as str:               \(serverTImeOnlyString)") }
        
        return ( serverDate!, serverString, serverTImeOnlyString  )
    }
    // problem area ---------------------------------------------------------------------
    
    // get difference in minutes
    func calcDiffInMinHours(from local: Date, server: Date, debug: Bool)-> (Bool, Int, Int, Int) {
        
        if ( debug ) { print("\t\t\t\tCalc Diff In Minutes") }
        var alert = false
        if ( debug ) { print("5. Subtract\t\(server)\tfrom\t\(local)") }
        var minuteTotal = Calendar.current.dateComponents([.minute], from: server, to: local).minute ?? 0
        let hours = Int(minuteTotal / 60)
        let minLeft = minuteTotal - ( hours * 60 )
        if minuteTotal > 1500 { minuteTotal = 30 }
        if ( debug ) { print("6. \(minuteTotal) minuteTotal,  \(hours) Hours, \(minLeft) minLeft") }
        if ( debug ) { print("--------------         Conversion finished     ---------------------\n") }
        
        // if greater that 30 mins send alert
        if (hours > 1 || minLeft > 31 ) {
            if ( debug ) { print("Late!") }
            alert = true
        }
        return (alert, hours, minLeft, minuteTotal)
    }
}

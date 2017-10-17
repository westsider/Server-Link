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
        if ( debug ) { print("\nConvert Server Date To Local Date------------------v") }
        if ( debug ) { print("EST:       \(server)") }
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let serverString = formatter.string(from: server)
        if ( debug ) { print("EST str: \(serverString)") }
        if ( debug ) { print( "should read 11:30 but reads 12:30") }
        
        // calc local equivilant of server time stamp
        let serverDate = formatter.date(from: serverString)
        if ( debug ) { print("local date \(serverDate!)") }
        
        // calc local equivilant of server hour:min stamp
        formatter.dateFormat = "HH:mm a"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let serverTImeOnlyString = formatter.string(from: serverDate!)
        if ( debug ) { print("local time \(serverTImeOnlyString)") }
        
        return ( serverDate!, serverString, serverTImeOnlyString  )
    }
    // problem area ---------------------------------------------------------------------
    
    // get difference in minutes
    func calcDiffInMinHours(from local: Date, server: Date, debug: Bool)-> (Bool, Int, Int, Int) {
        
        if ( debug ) { print("\nCalc Diff In Minutes ---------------------") }
        var alert = false
        if ( debug ) { print("Subtracting \(server) from \(local)") }
        let minuteTotal = Calendar.current.dateComponents([.minute], from: server, to: local).minute ?? 0
        let hours = Int(minuteTotal / 60)
        let minLeft = minuteTotal - ( hours * 60 )
        if ( debug ) { print("\nminuteTotal \(minuteTotal) Hours: \(hours) minLeft: \(minLeft)\n") }
        // if greater that 30 mins send alert
        
        if (hours > 1 || minLeft > 31 ) {
            if ( debug ) { print("Late!") }
            alert = true
        }
        return (alert, hours, minLeft, minuteTotal)
    }
}

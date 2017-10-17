//
//  UpdateViewController.swift
//  Server Link
//
//  Created by Warren Hansen on 10/16/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
/*
//MARK: - TODO
     [ ] tableview
     [ ] chart
     [ ] notifications
     [ ] reset circle at 0
*/
import UIKit
import UserNotifications


class UpdateViewController: UIViewController {

    @IBOutlet weak var serverConnectedLable: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var priceDifferenceLabel: UILabel!
    
    @IBOutlet weak var priceCurrentLabel: UILabel!
    
    @IBOutlet weak var lastUpdateTime: UILabel!
    
    @IBOutlet weak var serverConnectTime: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var lastPriceTop: UILabel!
    
    let firebaseLink = FirebaseLink()
    
    var currentLongEntryPrice:Double?
    
    var currentShortEntryPrice:Double?
    
    var myTimer = TimeUtility()
    
    var counter = 7 // this sets ring mode
    
    var alertForAnnimation = 0 //  [0, 5,10,15,20,25,30,35, 40, 45]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trade Server"
        firebaseLink.authFirebase()
        firebaseLink.fetchData(debug: false) { ( urlCallDone ) in
            if urlCallDone {
                print("firebase has updated the Prices Object")
                self.updateUISegmented()
            }
        }
        //initNotificaationSetupCheck()
    }

    func annimateCircle(alert:Int, reset: Bool) {
        
        let replicatorLayer = CAReplicatorLayer()
        if ( reset ) {
            replicatorLayer.removeFromSuperlayer()
        }
        replicatorLayer.frame = circleView.bounds
        replicatorLayer.instanceCount = alert   // alert[counter]
        replicatorLayer.instanceDelay = CFTimeInterval(1 / 30.0)
        replicatorLayer.preservesDepth = false
        replicatorLayer.instanceColor = UIColor.white.cgColor
        // blue layer
        replicatorLayer.instanceRedOffset = -0.6
        replicatorLayer.instanceGreenOffset = -0.6
        replicatorLayer.instanceBlueOffset =  0
        replicatorLayer.instanceAlphaOffset = 0.0
        
        let angle = Float(Double.pi * 2.0) / 30
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
        circleView.layer.addSublayer(replicatorLayer)
        let instanceLayer = CALayer()
        let layerWidth: CGFloat = 7.5
        let midX = circleView.bounds.midX - layerWidth / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerWidth * 3.0)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        replicatorLayer.addSublayer(instanceLayer)
        
        if alert >= 40 {
            // red layer
            replicatorLayer.instanceRedOffset = 0
            replicatorLayer.instanceGreenOffset = -0.5
            replicatorLayer.instanceBlueOffset =  -0.5
            replicatorLayer.instanceAlphaOffset = 0.0
            
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.fromValue = 0.0
            fadeAnimation.toValue = 1
            fadeAnimation.duration = 2
            fadeAnimation.repeatCount = Float.greatestFiniteMagnitude
            
            instanceLayer.opacity = 0.0
            instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
        }
    }

//    func initNotificaationSetupCheck() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ])
//        { ( success, error) in
//            if success {
//                print("\n*** Notifiation Permission Granted ***\n")
//            } else {
//                print("\n------------ There was a problem with permissions ---------------\n\(String(describing: error))")
//            }
//        }
//    }

    func sendNotification(content: [String]) {
//        let notification = UNMutableNotificationContent()
//        notification.title = content[0]
//        notification.subtitle = content[1]
//        notification.body = content[2]
//        notification.sound = UNNotificationSound.default()
//
//        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "Notification1", content: notification, trigger: notificationTrigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBAction func toobarTableViewAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "tableVC") as! TableViewController
        myVC.lastPriceList = firebaseLink.lastPriceList
        navigationController?.pushViewController(myVC, animated: true)
    }

    @IBAction func chartAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "chartVC") as! ChartViewController
        myVC.lastPriceList = firebaseLink.lastPriceList
        navigationController?.pushViewController(myVC, animated: true)
    }

    func updateUISegmented() {
        let lastUpdate = firebaseLink.lastPriceList.last
        var thisClose = 00.00
        calcEntryAndOpenProfit(lastUpdate: lastUpdate!, debug: false)
        thisClose = lastPriceLableCalc(lastUpdate: lastUpdate!)
        priceDifferenceLables(thisClose: thisClose)
        serverConnectedLable(lastUpdate: lastUpdate!, debug: false)
        serverConLable(lastUpdate: lastUpdate!)
    }
    
    func calcEntryAndOpenProfit(lastUpdate: LastPrice!, debug: Bool) {  // update devery 5 min RTH
        if (debug) {
            print("\ninLong: \(String(describing: lastUpdate.inLong)) inShort: \(String(describing: lastUpdate.inShort)) longE: \(String(describing: firebaseLink.currentLongEntryPrice)) shortE: \(String(describing: firebaseLink.currentShortEntryPrice)) close: \(String(describing: lastUpdate.close))\n")
        }
        if let inLong = lastUpdate.inLong,
            let inShort = lastUpdate.inShort,
            let close = lastUpdate.close {
            
            let longE:Double = firebaseLink.currentLongEntryPrice
            let shortE:Double = firebaseLink.currentShortEntryPrice
            var lastPriceUpdateTop:String?
            
            lastPriceTop.textColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
            
            if (inLong) {
                // clac Long Profit
                let longProfit = close - longE
                lastPriceUpdateTop = "Long \(String(describing: longE)) \(String(format: "%.2f", longProfit))"
                if (longProfit < 0) {
                    lastPriceTop.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else if (inShort) {
                // clac short Profit
                let shortProfit =   shortE - close
                //let shortP = String(format: "%.2f", shortProfit)
                lastPriceUpdateTop = "Short \(String(describing: shortE)) \(String(format: "%.2f", shortProfit))"
                if (shortProfit < 0){
                    lastPriceTop.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            } else {
                lastPriceUpdateTop = "System Is Flat"
                lastPriceTop.textColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            }
            
            lastPriceTop?.text = lastPriceUpdateTop!
        } else {
            lastPriceTop?.text = "Calc Profit Failed"
        }
    }
    
    func lastPriceLableCalc(lastUpdate: LastPrice)-> Double {
        if let theClose = lastUpdate.close {
            lastPriceLabel.text = String(theClose)
            return theClose
        } else {
            lastPriceLabel.text = "loading"
            return 0.0
        }
    }
    
    func priceDifferenceLables( thisClose: Double) {         // update devery 5 min RTH
        let index = firebaseLink.lastPriceList.count
        if (index > 3) {
            let priorBar = firebaseLink.lastPriceList[index-2]
            
            if let priorClose = priorBar.close {
                let priceDiff = thisClose - priorClose
                if (priceDiff >= 0) {
                    priceDifferenceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                // send alert if closes were the same
                if ( priceDiff == 0.0 ) {
                    let myContent = ["Server Status", "Suspicious Price", "Last two closes were the same"]
                    sendNotification(content: myContent)
                    priceDifferenceLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    priceDifferenceLabel.text = "Same Close!"
                }
                priceDifferenceLabel.text = String(format:"%.2f", priceDiff)
            } else {
                priceDifferenceLabel.text = "loading"
            }
        }
        upDateTimer()  // only at 6:30, 7, 730, 800, 830, 900, 930, 10, 1030, 1100, 1130,1200, 1230
        // this automatically syncs after 1st hour
    }
    
    // problem area -----------------------------------------------------------------------------------
    // may fail to work in other time zones
    func serverConnectedLable(lastUpdate: LastPrice, debug: Bool) {  // update devery 5 min RTH
        
        if (debug) {
            serverConnectTime?.text = "sConTime"
            priceCurrentLabel.text = "pCurLabel"
            lastUpdateTime.text =  "lUpdateTime"
        } else {
            if let lastTime = lastUpdate.date {
                
                let serverDateString = DateHelper().convertServeDateToLocal(server: lastTime, debug: true)
                let local = DateHelper().convertUTCtoLocal(debug: false, UTC: Date())
                let alert = DateHelper().calcDiffInMinHours(from: local, server: serverDateString.0, debug: true)
                
                if ( alert.0 ) {
                    print("\nSending late update alert!\n")
                    let myContent = ["Server Status", "Update is Late", "Last update was \(alert.1):\(alert.2) ago"]
                    sendNotification(content: myContent)
                }
                
                lastUpdateTime.text = serverDateString.2   // lower left high
                // alert.2 is the cue for the circle... 2, 5, 7, 10, 12
                // alertForAnnimation = alert.2
                let lastConnectionMinuteTotal = alert.3
                print("\nSending Data to animation circle! lastCommectionTotal: \(lastConnectionMinuteTotal) if 0 then reset!")
                var reset = false
                if ( lastConnectionMinuteTotal == 0 ) { reset = true}
                annimateCircle(alert: lastConnectionMinuteTotal, reset: reset)
                priceCurrentLabel.text = "\(alert.1):\(alert.2) elapsed"                                        // lower left low
            }
            
            if let serverDateTime = lastUpdate.connectTime {
                let serverDateTimeArr = serverDateTime.components(separatedBy: " ")
                if ( serverDateTimeArr.count < 3 ) {
                    serverConnectTime?.text = "parse time fail"               // Bottom -  upper right
                    return
                }
                serverConnectTime?.text = "\(serverDateTimeArr[1]) \(serverDateTimeArr[2])"     // Bottom -  upper right
            } else {
                serverConnectTime?.text = "No Data"                 // Bottom -  upper right
            }
        }
    }
    // problem area -----------------------------------------------------------------------------------
    // may fail to work in other time zones
    
    // Bottom lower right - Connected
    func serverConLable(lastUpdate: LastPrice){      // update devery 5 min RTH
        if let connectStat = lastUpdate.connectStatus {
            serverConnectedLable.text = connectStat
            let myContent = ["Server Status", "Connetion Update", connectStat] // watch skips middle subtitle
            if (connectStat != "Connected") {
                sendNotification(content: myContent)
            }
        } else {
            serverConnectedLable.text = "loading"
        }
    }
    
    func upDateTimer() {
        if ( myTimer.isMarketHours(begin: [6,35], end: [13,10])) {
            // 60 * 5 = 300 sec for 5 min
            myTimer.timerDuration(Seconds: 300) { ( finished ) in
                if finished {
                    DispatchQueue.main.async {
                        print("\nUpdating UI...")
                        self.updateUISegmented()
                    }
                }
            }
        }
    }
}


//
//  MainViewController.swift
//  Server Link
//
//  Created by Warren Hansen on 10/16/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

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
    
//    let firebaseLink = FirebaseLink()
//    
//    var currentLongEntryPrice:Double?
//    
//    var currentShortEntryPrice:Double?
//    
//    var myTimer = TimeUtility()
//    
//    var counter = 7 // this sets ring mode
//    
//    var alertForAnnimation = 0 //  [0, 5,10,15,20,25,30,35, 40, 45]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


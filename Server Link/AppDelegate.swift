//
//  AppDelegate.swift
//  Server Link
//
//  Created by Warren Hansen on 10/16/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ]) { (isGranted, err) in
            if err != nil {
                print("something bad happened in Notifiction auth")
            } else {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                print("\nNotifiction permission granted \(isGranted)")
                guard isGranted else { return }
                self.getNotificationSettings()
            }
        }
        
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let newToken = InstanceID.instanceID().token()
        print("\nToken: \(String(describing: newToken))\n")
        connectToFCM()
    }
    
    func connectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    // push notification functions
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .sound, .badge ])
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("\nDevice Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}


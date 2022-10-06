//
//  AppDelegate.swift
//  GogoFood
//
//  Created by YOGESH BANSAL on 07/02/20.
//  Copyright © 2020 YOGESH BANSAL. All rights reserved.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift
import GoogleMaps
import UserNotifications
import Firebase
import Localize_Swift
#if User
import FacebookCore
#endif



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let reachability = Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let language  = UserDefaults.standard.object(forKey: "LanguageKey") as? String{
            Localize.setCurrentLanguage(language)
        }
        
       GMSServices.provideAPIKey(AppConstant.googleKey)
        
        UIBarButtonItem.appearance().tintColor = AppConstant.appGrayColor
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        IQKeyboardManager.shared.enable = true
       
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
       
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        registerForPushNotifications()
        #if User
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        #endif
       
       
        return true
    }

    func setFireBaseDelegate() {
        if let fcmToken = InstanceID.instanceID().token() {
            print("Token : \(fcmToken)");
            CurrentSession.getI().localData.fireBaseToken = fcmToken
        } else {
            print("Error: unable to fetch token");
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    #if User
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    #endif
    
  
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
        }
        self.getNotificationSettings()
    }

    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //OnTap Notification
        let userInfo = response.notification.request.content.userInfo as? [String:Any]
        print(userInfo ?? [:])
     
//
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as? FeedDetailViewController
//        vc?.isFromPush = true
//        let rootNC = UINavigationController(rootViewController: vc!)
//        vc?.noti.isFromNoti = true
//        vc?.noti.dishID = 18
//        window?.rootViewController = rootNC
//        self.window?.makeKeyAndVisible()
//        //        let TestVC = MainStoryboard.instantiateViewController(withIdentifier: "FeedDetailViewController") as! TestVC
//        //        TestVC.chapterId = dict["chapter_id"] as? String ?? ""
//        //        TestVC.strSubTitle = dict["chapter"] as? String ?? ""
//        //        self.navigationC?.isNavigationBarHidden = true
//        //        self.navigationC?.pushViewController(TestVC, animated: true)
        completionHandler() // Display notification Banner
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Process notification content
        let userInfo = notification.request.content.userInfo as? [String:Any]
        if let type = userInfo?["gcm.notification.type"] as? String{
            if type == "comment"{
                NotificationCenter.default.post(name: .dishCommnets, object: nil, userInfo: userInfo)
            }else{
                NotificationCenter.default.post(name: .newOrders, object: nil, userInfo: userInfo)
            }
        }
        completionHandler([.alert, .sound]) // Display notification Banner
    }
    class func sharedAppDelegate() -> AppDelegate?
    {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        
        CurrentSession.getI().localData.fireBaseToken = fcmToken
       
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}

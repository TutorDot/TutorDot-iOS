//
//  AppDelegate.swift
//  TutorDot_iOS
//
//  Created by Sehwa Ryu on 29/06/2020.
//  Copyright © 2020 Sehwa Ryu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        //        let defaults = UserDefaults.standard
        //        if defaults.object(forKey: "isFirstTime") == nil {
        //            defaults.set("No", forKey:"isFirstTime")
        //            print("yes")
        //            let storyboard = UIStoryboard(name: "MainTab", bundle: nil) //Write your storyboard name
        //            let viewController = storyboard.instantiateViewController(withIdentifier: "TabbarVC")
        //            self.window?.rootViewController = viewController
        //            self.window?.makeKeyAndVisible()
        //        }
        //guard let windowScene = (scene as? UIWindowScene) else { return }

//        if !UserDefaults.standard.bool(forKey: "didSee") {
//            UserDefaults.standard.set(true, forKey: "didSee")
//            print("donedone")
//            //self.window = UIWindow(windowScene: windowScene)
//            let storyboard = UIStoryboard(name: "Splash", bundle: nil)
//            guard let rootVC = storyboard.instantiateViewController(identifier: "SplashVC") as? SplashVC else {
//                print("ViewController not found")
//                return true
//            }
//            let rootNC = UINavigationController(rootViewController: rootVC)
//            rootNC.isNavigationBarHidden = true
//            self.window?.rootViewController = rootNC
//            self.window?.makeKeyAndVisible()
//
//        } else if UserDefaults.standard.bool(forKey: "didSee") == true {
//            //self.window = UIWindow(windowScene: windowScene)
//            print("yay")
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            guard let rootVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC else {
//                print("ViewController not found")
//                return true
//            }
//            let rootNC = UINavigationController(rootViewController: rootVC)
//            rootNC.isNavigationBarHidden = true
//            self.window?.rootViewController = rootNC
//            self.window?.makeKeyAndVisible()
//        }
        
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}


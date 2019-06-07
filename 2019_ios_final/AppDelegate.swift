//
//  AppDelegate.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許接收信息通知")
            } else {
                print("不允許接收信息通知")
            }
        })
        
        UNUserNotificationCenter.current().delegate = self

        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:  @escaping () -> Void) {
        
        let content = response.notification.request.content
        let identifier = response.notification.request.identifier
        if identifier == "message" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let destinationViewController1 = storyboard.instantiateViewController(withIdentifier: "ChatMenu") as! ChatMenuViewController
            let destinationViewController2 = storyboard.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController
            let propicName = Friend.getPropic(name: content.userInfo["sender"] as! String) ?? ""
            destinationViewController2.receiver = Friend(propic: propicName, name: content.userInfo["sender"] as! String)
            
            
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            tabBarController.selectedIndex = 1
            let navigationController = tabBarController.selectedViewController as! UINavigationController
            
            navigationController.pushViewController(destinationViewController1, animated: false)
            navigationController.pushViewController(destinationViewController2, animated: false)
            self.window?.rootViewController =  tabBarController
            
            
            
        } else {

            NetworkController.shared.getProfile(name: content.userInfo["sender"] as! String, completion: { status, data in
                if let data = data, let profile = try? JSONDecoder().decode(Friend.self, from: data) {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! AddFriendViewController
                        destinationViewController.target = profile
                        
                        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        tabBarController.selectedIndex = 0
                        let navigationController = tabBarController.selectedViewController as! UINavigationController
                        navigationController.pushViewController(destinationViewController, animated: false)
                        self.window?.rootViewController =  tabBarController


                    }
                }
            })
        }
        
        completionHandler()
    }
}


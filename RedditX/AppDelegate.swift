//
//  AppDelegate.swift
//  RedditX
//
//  Created by Gina Mullins on 9/18/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var homeVC: HomeVC!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        homeVC = HomeVC(viewModel: HomeVM(api: API()))
        window?.rootViewController = UINavigationController(rootViewController: homeVC)
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // NOTE:: this fixes a strange bug where the underline bar is reset when coming from background
        // not a permanent fix. still investigating - possible causes:
        // 1. snapshot error
        // 2. removing SceneDelegate
        
        homeVC.refresh()
    }

}


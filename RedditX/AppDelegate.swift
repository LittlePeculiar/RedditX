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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: HomeVC(viewModel: HomeVM(api: API())))
        
        window?.makeKeyAndVisible()
        
        return true
    }

}


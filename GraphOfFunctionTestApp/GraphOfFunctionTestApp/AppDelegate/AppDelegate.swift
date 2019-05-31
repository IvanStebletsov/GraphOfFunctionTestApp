//
//  AppDelegate.swift
//  GraphOfFunctionTestApp
//
//  Created by Ivan Stebletsov on 30/05/2019.
//  Copyright © 2019 Ivan Stebletsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Application lifecicle methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let graphVCVM = GraphVCVM()
        let graphVC = GraphVC(viewModel: graphVCVM)
        
//        window?.rootViewController = UINavigationController(rootViewController: graphVC)
        window?.rootViewController = graphVC
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}


//
//  AppDelegate.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // Global static instance, Unity style
    static var instance: AppDelegate!
    
    var window: UIWindow?
    var persistentContainer: NSPersistentContainer!

    override init() {
        super.init()
        AppDelegate.instance = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreDataStack.createMuLightContainer { container in
            guard let container = container else { return }
            self.persistentContainer = container
            guard let vc = NavigationController.storyboardInstance()
                else { fatalError("Cannot instantiate root view controller") }
            self.window?.rootViewController = vc
        }
        
        return true
    }
}


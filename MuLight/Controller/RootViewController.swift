//
//  RootViewController.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData

final class RootViewController: UIViewController, MuLightContext {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // TODO: present photo picker
    @IBAction func takePhoto(_ sender: UIButton) {
        print("takePhoto")
    }
    
    @IBAction func showPhotos(_ sender: UIButton) {
        let vc = PhotoTableViewController.storyboardInstance()
        navigationController?.pushViewController(vc, animated: true)
    }
}

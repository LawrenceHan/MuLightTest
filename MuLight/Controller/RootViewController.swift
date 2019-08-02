//
//  RootViewController.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/1.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

final class RootViewController: UIViewController, MuLightContext {
    
    var imagePicer: ImagePicker!
    private weak var saveAction: UIAlertAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicer = ImagePicker(self, delegate: self)
    }
    
    // TODO: present photo picker
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicer.present()
    }
    
    @IBAction func showPhotos(_ sender: UIButton) {
        guard let vc = PhotoTableViewController.storyboardInstance() else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image?.scaled() else { return }
        
        let alert = UIAlertController(title: "Give photo a name", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Save", style: .default) { _ in
            guard let caption = alert.textFields?.first?.text else {
                return
            }
            
            // Save to database
            Image.insert(into: self.muLightContext, caption: caption, photo: image)
        }
        ok.isEnabled = false
        
        let cancel = UIAlertAction(title: "Discard", style: .cancel, handler: nil)
        
        alert.addTextField { textField in
            textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
        saveAction = ok
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let enabled = textField.text?.isEmpty ?? true
        saveAction?.isEnabled = !enabled
    }
}

//
//  PhotoDetailViewController.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/3.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTouched))
        navigationItem.rightBarButtonItem = delete
        updateUI()
    }
    
    // MARK: - Private
    
    private func updateUI() {
        guard let image = image else { return }
        title = image.caption
        imageView.image = ImageStore.imageForKey(key: image.id)
    }
    
    @objc private func deleteTouched(_ sender: UIBarButtonItem) {
        if let image = image {
            image.managedObjectContext?.performChanges {
                image.managedObjectContext?.delete(image)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

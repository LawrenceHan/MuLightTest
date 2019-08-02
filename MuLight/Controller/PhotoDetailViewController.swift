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
        guard let image = image else { return }
        title = image.caption
        imageView.image = ImageStore.imageForKey(key: image.id)
    }
}

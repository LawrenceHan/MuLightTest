//
//  ImageStore.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit

class ImageStoreImpl {
    
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(for key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        )
        let documentDirectory = documentsDirectories.first!
        // or we could use group path
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(for: key)
        guard let data = image.jpegData(compressionQuality: 0.93) else {
            print("image.jpegData failed")
            return
        }
        do { try data.write(to: url, options: .atomic) } catch { print(error) }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        } else {
            let url = imageURL(for: key)
            
            guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
                return nil
            }
            
            cache.setObject(imageFromDisk, forKey: key as NSString)
            return imageFromDisk
        }
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as NSString)
        
        let url = imageURL(for: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    // MARK: Private
    
    private lazy var documentsPath: String = {
        // we could use this for group folder
        let groupName = "group." + Bundle.main.bundleIdentifier!
        return ""
    }()
}

// Single Instance
let ImageStore = ImageStoreImpl()

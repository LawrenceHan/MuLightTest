//
//  Foundation.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit

// MARK: - Foundation extension

extension CGSize {
    
    func aspectFitted(_ size: CGSize) -> CGSize {
        let scale = min(size.width / max(1.0, self.width), size.height / max(1.0, self.height))
        return CGSize(width: floor(self.width * scale), height: floor(self.height * scale))
    }
    
    func aspectFittedOrSmaller(_ size: CGSize) -> CGSize {
        let scale = min(1.0, min(size.width / max(1.0, self.width), size.height / max(1.0, self.height)))
        return CGSize(width: floor(self.width * scale), height: floor(self.height * scale))
    }
}

// MARK: - UIImage Helper

extension UIImage {
    func thumbnailData(_ fitSize: CGSize = CGSize(width: 320, height: 320)) -> Data {
        if let scaledImage = Scale(self, to: size.aspectFitted(fitSize)), let scaledData = scaledImage.jpegData(compressionQuality: 0.4) {
            return scaledData
        }
        return Data()
    }
    
    func scaled(_ maxSize: CGSize = CGSize(width: 1280, height: 1280)) -> UIImage? {
        return Scale(self, to: size.aspectFittedOrSmaller(maxSize))
    }
}

func Scale(_ image: UIImage, to size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .copy, alpha: 1)
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return scaledImage
}

// MARK: UIStoryboard support

protocol StoryboardInitializable: class {
    static func storyboardInstance() -> Self?
}

extension StoryboardInitializable where Self: UIViewController {
    static func storyboardInstance() -> Self? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let instance = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self else {
            print("\(self) cannot be init from storyboard")
            return nil
        }
        return instance
    }
}

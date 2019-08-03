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
    
    func fitted(_ size: CGSize) -> CGSize {
        var fittedSize = self
        if fittedSize.width > size.width {
            fittedSize = CGSize(width: size.width, height: floor((fittedSize.height * size.width / max(fittedSize.width, 1.0))))
        }
        if fittedSize.height > size.height {
            fittedSize = CGSize(width: floor((fittedSize.width * size.height / max(fittedSize.height, 1.0))), height: size.height)
        }
        return fittedSize
    }
}

// MARK: - UIImage Helper

extension UIImage {
    func thumbnailData(_ fitSize: CGSize = CGSize(width: 50, height: 50)) -> Data {
        let scaledSize = size.fitted(fitSize)
        if let scaledImage = generateScaledImage(image: self, size: scaledSize, scale: 1.0), let scaledData = scaledImage.jpegData(compressionQuality: 0.4) {
            return scaledData
        }
        return Data()
    }
    
    func scaled(_ maxSize: CGSize = CGSize(width: 1280, height: 1280)) -> UIImage? {
        let scaledSize = size.fitted(maxSize)
        guard let scaledImage = generateScaledImage(image: self, size: scaledSize, scale: 1.0) else {
            return nil
        }
        return scaledImage
    }
}

func generateScaledImage(image: UIImage?, size: CGSize, scale: CGFloat? = nil) -> UIImage? {
    guard let image = image else {
        return nil
    }
    
    return generateImage(size, contextGenerator: { size, context in
        context.draw(image.cgImage!, in: CGRect(origin: CGPoint(), size: size))
    }, opaque: true, scale: scale)
}

func generateImage(_ size: CGSize, contextGenerator: (CGSize, CGContext) -> Void, opaque: Bool = false, scale: CGFloat? = nil) -> UIImage? {
    let selectedScale = scale ?? UIScreen.main.scale
    let scaledSize = CGSize(width: size.width * selectedScale, height: size.height * selectedScale)
    let bytesPerRow = (4 * Int(scaledSize.width) + 15) & (~15)
    let length = bytesPerRow * Int(scaledSize.height)
    let bytes = malloc(length)!.assumingMemoryBound(to: Int8.self)
    
    guard let provider = CGDataProvider(dataInfo: bytes, data: bytes, size: length, releaseData: { bytes, _, _ in
        free(bytes)
    })
        else {
            return nil
    }
    
    let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | (opaque ? CGImageAlphaInfo.noneSkipFirst.rawValue : CGImageAlphaInfo.premultipliedFirst.rawValue))
    
    guard let context = CGContext(data: bytes, width: Int(scaledSize.width), height: Int(scaledSize.height), bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue) else {
        return nil
    }
    
    context.scaleBy(x: selectedScale, y: selectedScale)
    
    contextGenerator(size, context)
    
    guard let image = CGImage(width: Int(scaledSize.width), height: Int(scaledSize.height), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo, provider: provider, decode: nil, shouldInterpolate: false, intent: .defaultIntent)
        else {
            return nil
    }
    
    return UIImage(cgImage: image, scale: selectedScale, orientation: .up)
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

//
//  ImagePicker.swift
//  MuLight
//
//  Created by Hanguang on 2019/8/2.
//  Copyright © 2019 hanguang. All rights reserved.
//

import UIKit
import AVFoundation

protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    
    init(_ presentationController: UIViewController, delegate: ImagePickerDelegate) {
        pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        #if !targetEnvironment(simulator)
        pickerController.sourceType = .camera
        #else
        pickerController.sourceType = .photoLibrary
        #endif
    }
    
    func present() {
        let cameraAuthorization = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorization {
        case .authorized:
            presentationController?.present(pickerController, animated: true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (authorized) in
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    if authorized {
                        self.presentationController?.present(self.pickerController, animated: true)
                    } else {
                        self.handleDeniedCameraAuthorization(self.presentationController)
                    }
                }
            })
        case .restricted, .denied:
            self.handleDeniedCameraAuthorization(presentationController)
        @unknown default:
            print("unknow cameraAuthorization type")
            break
        }
    }
    
    // MARK: Private
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        delegate?.didSelect(image: image)
    }
    
    private func handleDeniedCameraAuthorization(_ picker: UIViewController?) {
        let alert = UIAlertController(title: "No camera permissions granted", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(
            title: "Open Settings", style: .cancel, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
        }))
        picker?.present(alert, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {}

//
//  UserDetailViewController.swift
//  LaRede
//
//  Created by Alessandro on 23/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import Photos

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var empresaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { [weak self] (status) in
            if status == .authorized {
                self?.presentImagePicker()
            }
        }
    }

    @IBAction func editPhoto(_ sender: UIButton) {
        switch PHPhotoLibrary.authorizationStatus() {
            case .authorized: presentImagePicker()
            case .notDetermined: requestAuthorization()
            case .denied, .restricted: return
        }
    }
    
    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(picker, animated: true, completion: nil)
        }
    }
}

extension UserDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

//
//  UserDetailViewController.swift
//  LaRede
//
//  Created by Alessandro on 23/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: String?
    
    var email: String?
    
    var company: String?
    
    var albums = [Album]()

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var empresaLabel: UILabel!       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if let email = email {
            emailLabel.text = email
        }
        if let company = company {
            empresaLabel.text = company
        }
        albums = createAlbums()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailCell", for: indexPath) as! UserDetailTableViewCell        
        cell.show(with: albums[indexPath.row])
        return cell
    }
    
    private func createAlbums() -> [Album]{
        var albums = [Album]()
        for i in 0..<4 {
            let album = Album(name:"Férias \(i)", albumDescription: "Minhas férias viajando \(i)")
            album.photos.append(#imageLiteral(resourceName: "placeholder"))
            albums.append(album)
        }
        return albums
    }   
    
}

extension UserDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}


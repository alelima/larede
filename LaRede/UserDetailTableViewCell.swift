//
//  UserDetailTableViewCell.swift
//  LaRede
//
//  Created by Alessandro on 06/06/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserDetailTableViewCell: UITableViewCell {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var tituloLabel: UILabel!
    
    var photoDataSource: Album?
    let urlRequest = URLRequest(url: URL(string: "https://picsum.photos/100/?random")!)
    
    func show(with album: Album) {
        self.photoDataSource = album
        self.descricaoLabel.text = album.albumDescription
        self.tituloLabel.text = album.name        
        collectionView.dataSource = photoDataSource
        if photoDataSource?.photos.count == 0 {
            fillDataSource(numberOfPhotos: 5)
        }
    }
    
    func fillDataSource(numberOfPhotos: Int) {
        for _ in 0..<numberOfPhotos {
            Alamofire.request(urlRequest).responseImage {[unowned self] response in
                debugPrint(response.result)
                if let image = response.result.value {
                    if let album = self.photoDataSource {
                        album.photos.append(image)
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                }
            }
        }
    }
        
}

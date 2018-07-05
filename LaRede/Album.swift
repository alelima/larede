//
//  Album.swift
//  LaRede
//
//  Created by Alessandro on 04/07/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit

class Album: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var photos = [UIImage]()
    var name: String?
    var albumDescription: String?
    
    init(name: String, albumDescription: String) {
        self.name = name
        self.albumDescription = albumDescription        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UserPhotoCollectionCell"
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                               for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}

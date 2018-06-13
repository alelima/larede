//
//  UserDetailTableViewCell.swift
//  LaRede
//
//  Created by Alessandro on 06/06/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    let photoDataSource = PhotoDataSource()
    
    func showPhoto() {
        collectionView.dataSource = photoDataSource
    }
    
}

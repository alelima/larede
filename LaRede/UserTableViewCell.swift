//
//  UserTableCellTableViewCell.swift
//  LaRede
//
//  Created by Alessandro on 02/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    func configure(with user:User) {
        nameLabel.text = user.name
        userNameLabel.text = user.userName
    }

}

//
//  ActivityIndicator.swift
//  LaRede
//
//  Created by Alessandro on 14/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import UIKit

class ActivityIndicator {
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func show(in view: UIView) {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.startAnimating()
    }
    
    func stop() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

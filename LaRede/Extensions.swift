//
//  Extensions.swift
//  LaRede
//
//  Created by Alessandro on 27/06/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import Foundation

public extension String {
    static let kEmpty = ""
    
    static func localized(_ key:String, _ comment:String = kEmpty) -> String {
        return NSLocalizedString(key, comment: comment)
    }
}

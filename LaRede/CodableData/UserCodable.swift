//
//  User.swift
//  LaRede
//
//  Created by Alessandro on 02/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import Foundation

struct UserCodable: Codable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var phone: String?
    var website: String?
    
    struct Address: Codable {
        var street: String?
        var suite: String?
        var city: String?
        var zipcode: String?
        
        struct Geo: Codable {
            var lat: String?
            var lng: String?
        }
        
        let geo: Geo?
    }
    
    struct Company: Codable {
        var name: String?
        var catchPhrase: String?
        var bs: String?
    }
    
    let address: Address?
    let company: Company?
}

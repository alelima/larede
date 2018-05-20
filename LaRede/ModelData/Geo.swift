//
//  Geo.swift
//  ExercicioTableViewCoreData
//
//  Created by Alessandro on 10/04/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import CoreData

class Geo: NSManagedObject {
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}

extension Geo: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
    }
}

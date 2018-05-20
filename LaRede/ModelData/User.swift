//
//  User.swift
//  LaRede
//
//  Created by Alessandro on 05/05/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import CoreData

class User: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(with context: NSManagedObjectContext, _ userCodable: UserCodable) {
        let description = NSEntityDescription.entity(forEntityName: "User", in: context)
        super.init(entity: description!, insertInto: context)
        self.id = String(userCodable.id!)
        self.name = userCodable.name
        self.userName = userCodable.username
        self.email = userCodable.email
        self.phone = userCodable.phone
        self.website = userCodable.website
        self.address = convertAddress(with: userCodable, in: context)
        self.company = convertCompany(with: userCodable, in: context)
    }
    
    fileprivate func convertAddress(with userCodable: UserCodable, in context: NSManagedObjectContext) -> Address {
        let address = Address(context: context)
        address.city = userCodable.address?.city
        address.suite = userCodable.address?.suite
        address.zipcode = userCodable.address?.zipcode
        address.street = userCodable.address?.street
        address.geo = convertGeo(with: userCodable, in: context)
        return address
    }
    
    fileprivate func convertGeo(with userCodable: UserCodable, in context: NSManagedObjectContext) -> Geo{
        let geo = Geo(context: context)
        
        if let lng = userCodable.address?.geo?.lng {
            geo.lng = Double(lng)!
        }
        
        if let lat = userCodable.address?.geo?.lat {
            geo.lat  = Double(lat)!
        }
        
        return geo
    }
    
    fileprivate func convertCompany(with userCodable: UserCodable, in context: NSManagedObjectContext) -> Company {
        let company = Company(context: context)
        company.name = userCodable.company?.name
        company.catchPhrase = userCodable.company?.catchPhrase
        company.bs = userCodable.company?.name
        return company
    }
    
    
    // If exists user with passed id, returns persisted user, else returns a new user.
    static func getUser(from userCodable: UserCodable, with context: NSManagedObjectContext) -> User? {
        var user: User?
        guard let id = userCodable.id else { return user }
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "id = %d", id)
        request.predicate = predicate       
        
        do {
            var users = try context.fetch(request)
            if users.count > 0 {
                user = users[0]
            } else {
                user = User(with: AppDelegate.viewContext, userCodable)
            }
        } catch {
            debugPrint("Error in load Users")
        }
        
        return user
    }
    
    func getUserCodable() -> UserCodable {
        let ucAddressGeo = UserCodable.Address.Geo(lat: String(address!.geo!.lat), lng: String(address!.geo!.lng))
        let ucAddress = UserCodable.Address(street: address?.street, suite: address?.suite, city: address?.city, zipcode: address?.zipcode, geo: ucAddressGeo)
        let ucCompany = UserCodable.Company(name: company?.name, catchPhrase: company?.catchPhrase, bs: company?.bs)
        let uc = UserCodable(id: Int(id!), name: name, username: userName, email: email, phone: phone, website: website, address: ucAddress, company: ucCompany)
        return uc
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case userName = "username"
        case email
        case phone
        case website
    }

}

//extension User: Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//}

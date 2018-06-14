//
//  ListUserTests.swift
//  LaRedeTests
//
//  Created by Alessandro on 13/06/18.
//  Copyright © 2018 nitrox. All rights reserved.
//

import Quick
import Nimble

@testable import LaRede

class ListUserTest:QuickSpec {
    
    override func spec() {
        var subject: UserTableViewController!
        beforeEach {
            subject = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListUser") as? UserTableViewController
        }
        
        context("After view did load ") {
            it("Table not be null") {
                expect(subject.tableView).notTo(beNil())
            }
        }
    }
}

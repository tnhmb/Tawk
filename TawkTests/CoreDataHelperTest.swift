//
//  CoreDataHelperTest.swift
//  TawkTests
//
//  Created by Tareq Bashuaib on 10/06/2023.
//

import XCTest
@testable import Tawk

class CoreDataHelperTests: XCTestCase {
    
    var coreDataHelper: CoreDataHelper!

    override func setUp() {
        super.setUp()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coreDataHelper = CoreDataHelper(coreDataStack: appDelegate!.cdStack)
        
    }

    override func tearDown() {
        coreDataHelper = nil
        super.tearDown()
    }

    func testSaveFetchUser() {
        let user = UserEntityElement(login: "john", id: 123)
        
        coreDataHelper.saveUser(user)
        XCTAssertNotNil(coreDataHelper.getUser(withLogin: "john"))
    }

   

    func testSaveFetchProfile() {
        let profile = ProfileEntity(login: "john", name: "John Doe")

        coreDataHelper.saveProfile(profile)
        XCTAssertNotNil(coreDataHelper.getProfile(withLogin: "john"))
        
    }

    func testSaveFetchUsers() {
        let users = [UserEntityElement(login: "john", id: 123), UserEntityElement(login: "Alex", id: 113), UserEntityElement(login: "Max", id: 121)]
        
        coreDataHelper.saveUsers(users) {
            XCTAssert(true, "Saved user")
        }
        XCTAssertNotNil(coreDataHelper.getUsers())
    }
}

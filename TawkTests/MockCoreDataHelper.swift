//
//  MockCoreDataHelper.swift
//  TawkTests
//
//  Created by Tareq Bashuaib on 10/06/2023.
//

import Foundation
@testable import Tawk

class MockCoreDataHelper: CoreDataHelper {
    
    var didCallGetUsers = false
    var didCallSaveUsers = false
    
    var didCallGetProfile = false
    var didCallSaveProfile = false
    
    var mockUsers: [UserEntityElement]?
    var mockProfile: ProfileEntity?
    
    override func getUsers() -> [UserEntityElement]? {
        didCallGetUsers = true
        return mockUsers
    }
    
    override func saveUsers(_ users: [UserEntityElement]) {
        self.mockUsers = users
        didCallSaveUsers = true
    }
    
    override func getProfile(withLogin: String) -> ProfileMO? {
        didCallGetProfile = true
        return super.getProfile(withLogin: withLogin)
    }
    
    override func saveProfile(_ profile: ProfileEntity) {
        self.mockProfile = profile
        didCallSaveProfile = true
    }
}

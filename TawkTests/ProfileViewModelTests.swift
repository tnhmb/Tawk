//
//  ProfileViewModelTests.swift
//  TawkTests
//
//  Created by Tareq Bashuaib on 10/06/2023.
//

import XCTest
import Combine

@testable import Tawk
final class ProfileViewModelTests: XCTestCase {
    
    var sut: ProfileViewModel!
    var mockAPIClient: MockAPIClient!
    var mockCoreDataHelper: MockCoreDataHelper!
    
    override func setUp() {
        super.setUp()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        mockAPIClient = MockAPIClient()
        mockCoreDataHelper = MockCoreDataHelper(coreDataStack: appDelegate!.cdStack)
        sut = ProfileViewModel(apiClient: mockAPIClient, coreDataHelper: mockCoreDataHelper, username: "testuser")
    }
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        mockCoreDataHelper = nil
        super.tearDown()
    }
    
    func testGetData_FetchFromBackend_Success() {
        // Arrange
        let mockProfile = ProfileEntity(login: "testuser", name: "Test User")
        let expectedResult: Result<ProfileEntity, ErrorEntity> = .success(mockProfile)
        mockAPIClient.mockResult = expectedResult
        let expectaions = XCTestExpectation(description: "Success")
        let cancellable: AnyCancellable?
        
        cancellable = sut.$profileData
            .dropFirst()
            .sink(receiveValue: { value in
                expectaions.fulfill()
            })
        // Act
        sut.fetchDataFromBackend()
        
        wait(for: [expectaions], timeout: 5.0)
        // Assert
        XCTAssertEqual(sut.profileData?.login, mockProfile.login)
        XCTAssertEqual(sut.profileData?.name, mockProfile.name)
        XCTAssertNil(sut.onError)
        XCTAssertTrue(mockAPIClient.didCallGet)
        XCTAssertTrue(mockCoreDataHelper.didCallSaveProfile)
    }
    
    
    func testGetData_FetchFromBackend_Failure() {
        // Arrange
        let expectedError = ErrorEntity(errorMessage: "API Error")
        let expectedResult: Result<ProfileEntity, ErrorEntity> = .failure(expectedError)
        sut.onError = expectedError
        mockAPIClient.mockResult = expectedResult
        sut.profileData = nil
    
        
        // Assert
        XCTAssertNil(sut.profileData)
        XCTAssertEqual(sut.onError, expectedError)
        XCTAssertFalse(mockCoreDataHelper.didCallSaveProfile)
    }
    
    
    
}

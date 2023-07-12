//
//  HomeViewModelTests.swift
//  TawkTests
//
//  Created by Tareq Bashuaib on 09/06/2023.
//

import XCTest
@testable import Tawk

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockAPIClient: MockAPIClient!
    var mockCoreDataHelper: MockCoreDataHelper!
    
    override func setUp() {
        super.setUp()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        mockAPIClient = MockAPIClient()
        mockCoreDataHelper = MockCoreDataHelper(coreDataStack: appDelegate!.cdStack)
        sut = HomeViewModel(apiClient: mockAPIClient, coreDataHelper: mockCoreDataHelper)
    }
    
    override func tearDown() {
        mockAPIClient = nil
        mockCoreDataHelper = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testGetData_CoreDataHasData_Success() {
        // Arrange
        let mockUsers = [UserEntityElement(id: 1, login: "John"), UserEntityElement(id: 2, login: "Jane")]
        mockCoreDataHelper.mockUsers = mockUsers
        
        // Act
        sut.getData(page: 0)
        
        // Assert
        XCTAssertEqual(sut.userList, mockUsers)
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testGetData_CoreDataIsEmpty_Success() {
        // Arrange
        mockCoreDataHelper.saveUsers([]) {
            XCTAssert(true, "Save user")
        }
        
        // Act
        sut.getData(page: 0)
        
        // Assert
        XCTAssertEqual(sut.userList, [])
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(mockAPIClient.didCallGet)
        XCTAssertTrue(mockCoreDataHelper.didCallGetUsers)
        XCTAssertTrue(mockCoreDataHelper.didCallSaveUsers)
    }
    
    func testGetData_NetworkUnavailable_Error() {
        // Arrange
        mockAPIClient.mockError = ErrorEntity(errorMessage: "Network unavailable")
        
        // Act
        sut.getData(page: 0)
        
        // Assert
        XCTAssertEqual(sut.errorMessage, "Network unavailable")
        XCTAssertTrue(mockAPIClient.didCallGet)
    }
    
    func testFetchDataFromBackend_Success() {
        // Arrange
        let mockUsers = [UserEntityElement(id: 1, login: "John"), UserEntityElement(id: 2, login: "Jane")]
        let expectedResult: Result<[UserEntityElement], ErrorEntity> = .success(mockUsers)
        mockAPIClient.mockResult = expectedResult
        
        // Act
        sut.fetchDataFromBackend(page: 0)
        
        // Assert
        XCTAssertEqual(sut.userList, mockUsers)
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(mockAPIClient.didCallGet)
        XCTAssertTrue(mockCoreDataHelper.didCallSaveUsers)
    }
    
    func testFetchDataFromBackend_Failure() {
        // Arrange
        let mockError = ErrorEntity(errorMessage: "API error")
        let expectedResult: Result<[UserEntityElement], ErrorEntity> = .failure(mockError)
        mockAPIClient.mockResult = expectedResult
        
        // Act
        sut.fetchDataFromBackend(page: 0)
        
        // Assert
        XCTAssertEqual(sut.errorMessage, "API error")
        XCTAssertTrue(mockAPIClient.didCallGet)
        XCTAssertFalse(mockCoreDataHelper.didCallSaveUsers)
    }
    
}







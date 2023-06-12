//
//  MockAPIClient.swift
//  TawkTests
//
//  Created by Tareq Bashuaib on 10/06/2023.
//

import Foundation
@testable import Tawk
class MockAPIClient: APIClient {
    func post<T>(url: URL, data: T, completion: @escaping (Result<Data?, Tawk.ErrorEntity>) -> Void) where T : Encodable {
        
    }
    
    
    var didCallGet = false
    var mockResult: Any?
    var mockError: ErrorEntity?
    
    func get<T>(url: URL, completion: @escaping (Result<T, ErrorEntity>) -> Void) where T : Decodable {
        didCallGet = true
        
        if let result = mockResult as? Result<T, ErrorEntity> {
            completion(result)
        } else if let error = mockError {
            completion(.failure(error))
        }
    }
}

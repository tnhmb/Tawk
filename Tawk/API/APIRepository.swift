//
//  APIRepository.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
class APIRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, ErrorEntity>) -> Void) {
        apiClient.get(url: url) { (result: Result<T, ErrorEntity>) in
            completion(result)
        }
    }
    
    func postData<T: Encodable>(url: URL, data: T, completion: @escaping (Result<Data?, ErrorEntity>) -> Void) {
        apiClient.post(url: url, data: data) { (result: Result<Data?, ErrorEntity>) in
            completion(result)
        }
    }
}

//
//  APIClient.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import Foundation

protocol APIClient {
    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, ErrorEntity>) -> Void)
    func post<T: Encodable>(url: URL, data: T, completion: @escaping (Result<Data?, ErrorEntity>) -> Void)
}

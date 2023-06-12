//
//  URLSessionAPIClient.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//
import Foundation

class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let operationQueue: OperationQueue
    private let semaphore: DispatchSemaphore
    private let maxConcurrentRequests: Int
    
    init(maxConcurrentRequests: Int = 1) {
        self.session = URLSession(configuration: .default)
        self.operationQueue = OperationQueue()
        self.semaphore = DispatchSemaphore(value: maxConcurrentRequests)
        self.maxConcurrentRequests = maxConcurrentRequests
    }
    
    func get<T: Decodable>(url: URL, completion: @escaping (Result<T, ErrorEntity>) -> Void) {
        semaphore.wait()
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            self?.semaphore.signal()
            
            if let error = error {
                completion(.failure(ErrorEntity(error: error)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(ErrorEntity(errorMessage: "No data received.")))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(ErrorEntity(errorMessage: error.localizedDescription)))
            }
        }
        
        operationQueue.addOperation {
            task.resume()
        }
    }
    
    func post<T: Encodable>(url: URL, data: T, completion: @escaping (Result<Data?, ErrorEntity>) -> Void) {
        semaphore.wait()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let encodedData = try JSONEncoder().encode(data)
            request.httpBody = encodedData
        } catch {
            completion(.failure(ErrorEntity(errorMessage: error.localizedDescription)))
            return
        }
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.semaphore.signal()
            
            if let error = error {
                completion(.failure(ErrorEntity(error: error)))
                return
            }
            
            completion(.success(data))
        }
        
        operationQueue.addOperation {
            task.resume()
        }
    }
}

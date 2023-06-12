//
//  ErrorEntity.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation

public struct ErrorEntity: Codable, Error, Identifiable, Equatable {
    public var id = UUID() 
    var errorCode: Int?
    var status: Bool = false
    var errorMessage: String

    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    init(code: Int, message: String) {
        self.errorMessage = message
        errorCode = code
    }
    
    init(error: Error?) {
        if let error = error as NSError? {
            self.errorCode = error.code
            self.errorMessage = error.localizedDescription
        } else {
            self.errorMessage = "Unexpected error."
        }
    }
    
}

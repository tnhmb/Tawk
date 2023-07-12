//
//  Enums.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import CoreData
import UIKit

enum TypeEnum: String, Codable {
   case organization = "Organization"
   case user = "User"
}


enum CodingKeys: String, CodingKey {
    case errorCode = "ErrorCode"
    case status = "status"
    case errorMessage = "message"
}


enum CoreDataUserResult {
    case success(UserMO)
    case error(ErrorEntity)
    case unknownError
}

enum CoreDataUsersResult {
    case success([UserEntityElement])
    case error(ErrorEntity)
    case unknownError
}


enum CellType: String {
    case note = "NoteCell"
    case normal = "NormalCell"
    case inverted = "InvertedCell"
}

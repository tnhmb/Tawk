//
//  NoteDataModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import Foundation
class NoteDataModel: HomeDataModel {
    var avatar: String
    
    var userName: String
    
    var details: TypeEnum
    
    init(user: UserEntityElement) {
        avatar = user.avatarURL ?? ""
        userName = user.login ?? ""
        details = user.type ?? .user
    }
}

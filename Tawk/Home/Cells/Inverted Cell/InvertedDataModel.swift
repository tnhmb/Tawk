//
//  InvertedDataModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
struct InvertedDataModel: HomeDataModel {
    let avatar: String
    let userName: String
    let details: TypeEnum
    
    init(user: UserEntityElement) {
        avatar = user.avatarURL ?? ""
        userName = user.login ?? ""
        details = user.type ?? .user
    }
}

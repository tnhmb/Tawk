//
//  HomeDataModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class HomeDataModel {
    var avatar: String
    var userName: String
    var details: TypeEnum
    var cellType: CellType
    var index: Int
    
    init(user: UserEntityElement, index: Int) {
        self.avatar = user.avatarURL ?? ""
        self.userName = user.login ?? ""
        self.details = user.type ?? .user
        self.index = index
        if user.hasNote() {
            cellType = .note
        } else {
            cellType = .normal
        }
        
        if index % 4 == 3 {
            cellType = .inverted
        }
    }
}

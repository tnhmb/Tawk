//
//  HomeDataModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

protocol HomeDataModel {
    var avatar: String { get }
    var userName: String { get }
    var details: TypeEnum { get }
}

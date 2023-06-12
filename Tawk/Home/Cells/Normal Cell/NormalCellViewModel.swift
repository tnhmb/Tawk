//
//  NormalCellViewModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class NormalCellViewModel: HomeCellViewModel {
    let dataModel: HomeDataModel
    
    init(dataModel: HomeDataModel) {
        self.dataModel = dataModel
    }
    
    func configure(cell: HomeCell) {
        guard let normalCell = cell as? NormalCell else {
            return
        }
        
        normalCell.nameLabel.text = dataModel.userName
        normalCell.avatarIv.loadImage(from: dataModel.avatar)
        normalCell.detailsLabel.text = dataModel.details.rawValue
    }
}

//
//  NoteCellViewModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation

class NoteCellViewModel: HomeCellViewModel {
    let dataModel: HomeDataModel
    
    init(dataModel: HomeDataModel) {
        self.dataModel = dataModel
    }
    
    func configure(cell: HomeCell) {
        guard let noteCell = cell as? NoteCell else {
            return
        }
        
        noteCell.noteIv.isHidden = false
        noteCell.nameLabel.text = dataModel.userName
        noteCell.avatarIv.loadImage(from: dataModel.avatar)
        noteCell.detailsLabel.text = dataModel.details.rawValue
    }
}

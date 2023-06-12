//
//  InvertedCell.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class InvertedCell: UICollectionViewCell, HomeCell {
    @IBOutlet weak var avatarIv: UIImageView! {
        didSet {
            avatarIv.layer.cornerRadius = avatarIv.frame.height/2
            avatarIv.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = ""
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = ""
        }
    }
    
    func configure(with viewModel: HomeCellViewModel) {
        guard let invertedViewModel = viewModel as? InvertedCellViewModel else {
            return
        }
        
        // Configure the cell using the provided view model
        invertedViewModel.configure(cell: self)
    }
}

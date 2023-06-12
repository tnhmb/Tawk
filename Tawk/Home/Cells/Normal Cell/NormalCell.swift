//
//  NormalCell.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class NormalCell: UICollectionViewCell, HomeCell {
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
        guard let normalCellViewModel = viewModel as? NormalCellViewModel else {
            return
        }
        
        normalCellViewModel.configure(cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarIv.image = nil
    }
}

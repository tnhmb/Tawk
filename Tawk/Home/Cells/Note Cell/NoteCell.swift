//
//  NoteCell.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class NoteCell: UICollectionViewCell, HomeCell {
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
    
    @IBOutlet weak var noteIv: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = ""
        }
    }
    
    func configure(with model: HomeDataModel) {
            noteIv.isHidden = false
            nameLabel.text = model.userName
            avatarIv.loadImage(from: model.avatar)
            detailsLabel.text = model.details.rawValue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarIv.image = nil
    }
}

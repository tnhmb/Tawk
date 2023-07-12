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
    
    func configure(with model: HomeDataModel) {
            invertAvatarImageColor(avatarIv, from: model.avatar)
            detailsLabel.text = model.details.rawValue
            nameLabel.text = model.userName
    }
    
    private func invertAvatarImageColor(_ imageView: UIImageView, from url: String) {
        imageView.loadImage(from: url, completion: { image in
            guard let image = image else {
                return
            }
            
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            let filter = CIFilter(name: "CIColorInvert")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            
            guard let outputCIImage = filter?.outputImage else {
                return
            }
            
            let context = CIContext(options: nil)
            
            guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
                return
            }
            
            let invertedImage = UIImage(cgImage: outputCGImage)
            imageView.image = invertedImage
        })
    }
}

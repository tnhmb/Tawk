//
//  InvertedCellViewModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit
import CoreImage

class InvertedCellViewModel: HomeCellViewModel {
    private var dataModel: InvertedDataModel
    
    init(dataModel: InvertedDataModel) {
        self.dataModel = dataModel
    }
    
    func configure(cell: HomeCell) {
        guard let invertedCell = cell as? InvertedCell else {
            return
        }
        
        invertAvatarImageColor(invertedCell.avatarIv, from: dataModel.avatar)
        invertedCell.detailsLabel.text = dataModel.details.rawValue
        invertedCell.nameLabel.text = dataModel.userName
        
        
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

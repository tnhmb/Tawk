//
//  HomeCellProtocol.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

protocol HomeCell: UICollectionViewCell {
    func configure(with viewModel: HomeCellViewModel)
}

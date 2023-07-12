//
//  SpinnerCell.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 12/07/2023.
//

import Foundation
import UIKit

class SpinnerCell: UICollectionViewCell {
    
    @IBOutlet weak var spinnerView: UIActivityIndicatorView! {
        didSet {
            spinnerView.isHidden = true
        }
    }
    
    func startAnimating() {
        spinnerView.startAnimating()
        spinnerView.isHidden = false
    }
    
    func stopAnimating() {
        spinnerView.stopAnimating()
        spinnerView.isHidden = true
    }
}

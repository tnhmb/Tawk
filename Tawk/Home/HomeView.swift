//
//  HomeView.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit

class HomeView: UIView {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0

            collectionView.collectionViewLayout = flowLayout
            collectionView.register(UINib(nibName: "NormalCell", bundle: nil), forCellWithReuseIdentifier: "NormalCell")
            collectionView.register(UINib(nibName: "NoteCell", bundle: nil), forCellWithReuseIdentifier: "NoteCell")
            collectionView.register(UINib(nibName: "InvertedCell", bundle: nil), forCellWithReuseIdentifier: "InvertedCell")
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customInit()
    }
    
    func customInit() {
        self.fromNib()
    }
}

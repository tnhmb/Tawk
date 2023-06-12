//
//  HomeViewController.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    var layoutView: HomeView { return view as! HomeView }
    var viewModel: HomeViewModel!
    
    override func loadView() {
        view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupBinding()
        layoutView.collectionView.dataSource = self
        layoutView.collectionView.delegate = self
        layoutView.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startObservingNetworkChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObservingNetworkChanges()
    }
    
    private func fetchData() {
        viewModel.getData(page: 0)
    }
    
    func setupBinding() {
        viewModel.onError = { [weak self] error in
            // Show error message on fail
            self?.showErrorMessage(error.errorMessage, completion: nil)
        }
        
        viewModel.onFetchSuccess = { [weak self] in
            // Update your UI or perform any necessary actions upon successful data fetch
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        // Populate filteredUserList with initial data
        viewModel.filteredUserList = viewModel.userList
        // Update your UI to reflect the fetched data
        DispatchQueue.main.async {
            self.layoutView.collectionView.reloadData()
        }
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredUserList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = viewModel.filteredUserList[indexPath.item]
        let cell: HomeCell
        if indexPath.item % 4 == 3 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvertedCell", for: indexPath) as! InvertedCell
            let invertedDataModl = InvertedDataModel(user: data)
            let invertedCellViewModel = InvertedCellViewModel(dataModel: invertedDataModl)
            
            cell.configure(with: invertedCellViewModel)
        } else if data.hasNote() {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
            let noteDataModel = NoteDataModel(user: data)
            let noteCellViewModel = NoteCellViewModel(dataModel: noteDataModel)
            
            cell.configure(with: noteCellViewModel)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCell", for: indexPath) as! NormalCell
            let normalDataModel = NormalDataModel(user: data)
            let normalCellViewModel = NormalCellViewModel(dataModel: normalDataModel)
            
            cell.configure(with: normalCellViewModel)
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let selectedData = viewModel.filteredUserList[indexPath.item]
        if let username = selectedData.login {
            let profileViewModel = ProfileViewModel(coreDataHelper: CoreDataHelper(coreDataStack: appDelegate.cdStack), username: username)
            var profileView = ProfileView(viewModel: profileViewModel)
            
            profileView.onDismiss = { [weak self] in
                // Handle UI update
                self?.viewModel.getData(page: 0)
            }
            
            // Create a UIHostingController to present the SwiftUI view
            let hostingController = UIHostingController(rootView: profileView)
            navigationController?.pushViewController(hostingController, animated: true)
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let userList = viewModel.userList
        let lastItem = userList.count - 1
        if indexPath.item == lastItem {
            // User is about to reach the end of the collection view, load more data
            let nextPage = viewModel.currentPage
            viewModel.getData(page: nextPage)
        }
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredUserList = searchText.isEmpty ? viewModel.userList : viewModel.userList.filter { user in
            // Filter the user list based on username and note fields
            let usernameMatch = user.login?.lowercased().contains(searchText.lowercased()) ?? false
            let noteMatch = user.note?.lowercased().contains(searchText.lowercased()) ?? false
            return usernameMatch || noteMatch
        }
        
        layoutView.collectionView.reloadData()
    }
}

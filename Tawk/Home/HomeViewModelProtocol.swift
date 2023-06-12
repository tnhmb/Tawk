//
//  HomeViewModelProtocol.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation

protocol HomeViewModelProtocol: FetchAPIProtocol {
    var userList: [UserEntityElement] { get }
    var filteredUserList: [UserEntityElement] { get }
    var coreDataHelper: CoreDataHelper { get set }
    var errorMessage: String? { get set }
    var currentPage: Int { get set }
    func getData(page: Int)
    func startObservingNetworkChanges()
    func stopObservingNetworkChanges()
    func fetchDataFromBackend(page: Int)
}

//
//  ProfileViewModelProtocol.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
protocol ProfileViewModelProtocol: ObservableObject {
    var profileData: ProfileEntity? { get set }
    var onError: ErrorEntity? { get set }
    var coreDataHelper: CoreDataHelper { get }
    var username: String { get}
    func getData()
    func startObservingNetworkChanges()
    func stopObservingNetworkChanges()
}

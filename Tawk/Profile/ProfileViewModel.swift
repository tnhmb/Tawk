//
//  ProfileViewModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import Network

class ProfileViewModel: ProfileViewModelProtocol {
    @Published var profileData: ProfileEntity?
    @Published var onError: ErrorEntity?
    var username: String
    var coreDataHelper: CoreDataHelper
    private let apiClient: APIClient
    private let networkMonitor = NWPathMonitor()
    private var isObservingNetwork = false
    private var dataUpdateTimer: Timer?
    private let updateInterval: TimeInterval = 60 * 30
        
    
    init(apiClient: APIClient = URLSessionAPIClient(), coreDataHelper: CoreDataHelper, username: String) {
        self.username = username
        self.apiClient = apiClient
        self.coreDataHelper = coreDataHelper
    }
    
    func getData() {
        if let coreDataResult = coreDataHelper.getProfile(withLogin: username) {
            DispatchQueue.main.async {
                self.profileData = ProfileEntity(profile: coreDataResult)
            }
        } else {
            fetchDataFromBackend()
        }
    }
    
    func fetchDataFromBackend() {
        if !isNetworkAvailable() {
            onError = ErrorEntity(errorMessage: "Network unavailable")
            return
        }
        
        guard let url = URL(string: "https://api.github.com/users/\(username)") else {
            return
        }
        
        apiClient.get(url: url) { [weak self] (result: Result<ProfileEntity, ErrorEntity>) in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.profileData = profile
                }
                self?.coreDataHelper.saveProfile(profile)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError = ErrorEntity(error: error)
                }
            }
        }
    }
    func startObservingNetworkChanges() {
        // Start obserbing network changes
        if isObservingNetwork { return }
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.retryFetchingDataIfNeeded()
            }
        }
        
        let queue = DispatchQueue(label: "network-monitor")
        networkMonitor.start(queue: queue)
        isObservingNetwork = true
        dataUpdateTimer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)

    }
    
    func stopObservingNetworkChanges() {
        // Stop observing network changes
        networkMonitor.cancel()
        isObservingNetwork = false
        dataUpdateTimer?.invalidate()
               dataUpdateTimer = nil
    }
    
    @objc private func updateData() {
            fetchDataFromBackend()
    }
    
    private func retryFetchingDataIfNeeded() {
        DispatchQueue.main.async {
            self.getData()
        }
    }
    
    func isNetworkAvailable() -> Bool {
        guard let url = URL(string: "https://www.google.com") else {
            return false
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (_, _, _) in }
        task.resume()
        
        return true
    }
}

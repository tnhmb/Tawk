//
//  HomeViewModel.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import Network

class HomeViewModel: HomeViewModelProtocol {
    var userList: [UserEntityElement] = []
    var filteredUserList: [UserEntityElement] = []
    private let apiClient: APIClient
    var coreDataHelper: CoreDataHelper
    private let networkMonitor = NWPathMonitor()
    private var isObservingNetwork = false
    var errorMessage: String?
    var currentPage: Int = 0
    
    private var dataUpdateTimer: Timer?
    private let updateInterval: TimeInterval = 60 * 30
    
    var onError: ((ErrorEntity) -> Void)?
    var onFetchSuccess: (() -> Void)?
    
    init(apiClient: APIClient = URLSessionAPIClient(), coreDataHelper: CoreDataHelper) {
        self.apiClient = apiClient
        self.coreDataHelper = coreDataHelper
    }
    
    func getData(page: Int) {
        // First, try to fetch data from Core Data
        if let coreDataResult = coreDataHelper.getUsers() {
            if !coreDataResult.isEmpty {
                userList = coreDataResult
                self.currentPage = userList.last?.id ?? page
                DispatchQueue.main.async {
                    self.onFetchSuccess?()
                }
                // Fetch new data from the backend in the background
                fetchDataFromBackend(page: self.currentPage)
            } else {
                fetchDataFromBackend(page: page)
            }
        } else {
            fetchDataFromBackend(page: page)
        }
    }
    
    func fetchDataFromBackend(page: Int) {
        if !isNetworkAvailable() {
            onError?(ErrorEntity(errorMessage: "Network unavailable"))
            errorMessage = "Network unavailable"
            return
        }
        guard let url = URL(string: "https://api.github.com/users?since=\(page)") else {
            return
        }
        
        // Set isFetchingData to true to prevent multiple simultaneous API calls
        
        
        apiClient.get(url: url) { [weak self] (result: Result<[UserEntityElement], ErrorEntity>) in
            // Set isFetchingData to false after the API call is completed
            switch result {
            case .success(let users):
                self?.userList += users
                self?.currentPage = users.last?.id ?? 0
                self?.coreDataHelper.saveUsers(users) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self?.onFetchSuccess?()

                    })
                }
               
            case .failure(let error):
                self?.errorMessage = error.errorMessage
                self?.onError?(error)
            }
        }
    }
    
    func startObservingNetworkChanges() {
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
        networkMonitor.cancel()
        isObservingNetwork = false
        dataUpdateTimer?.invalidate()
        dataUpdateTimer = nil
    }
    
    @objc private func updateData() {
        // Fetch updated data from the backend
        userList = []
        fetchDataFromBackend(page: 0)
    }
    
    private func retryFetchingDataIfNeeded() {
        DispatchQueue.main.async {
            if self.userList.isEmpty {
                self.getData(page: self.currentPage)
            }
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

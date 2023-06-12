//
//  FetchAPIProtocol.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
protocol FetchAPIProtocol: AnyObject {
    var onError: ((ErrorEntity) -> Void)? { get set }
    var onFetchSuccess: (() -> Void)? { get set }
    func isNetworkAvailable() -> Bool
}

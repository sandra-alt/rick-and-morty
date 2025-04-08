//
//  NetworkMonitor.swift
//  RickAndMorty
//
//  Created by  Oleksandra on 08.04.2025.
//

import Foundation
import Network

extension Notification.Name {
    static let connectivityChanged = Notification.Name("connectivityChanged")
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = true {
        didSet {
            if oldValue != isConnected {
                NotificationCenter.default.post(
                    name: .connectivityChanged,
                    object: nil,
                    userInfo: ["isConnected": isConnected]
                )
            }
        }
    }
    
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

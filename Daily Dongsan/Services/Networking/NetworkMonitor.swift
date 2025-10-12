//
//  NetworkMonitor.swift
//  Daily Dongsan
//
//  Created by 최지한 on 5/5/25.
//

import SwiftUI
import Network

@Observable
class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    var isConnected: Bool = true
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                withAnimation {
                    self.isConnected = path.status == .satisfied
                }
            }
        }
    }
}

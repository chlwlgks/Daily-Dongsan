//
//  NetworkMonitor.swift
//  Daily Dongsan
//
//  Created by 최지한 on 5/5/25.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool = true
    
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

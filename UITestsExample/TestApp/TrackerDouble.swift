//
//  TrackerDouble.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import Foundation

class TrackerDouble: TrackerProtocol {
    
    private static let serverURL: URL! = URL(string: "http:/[::1]:8080")
    
    init() {
        // nop
    }
    
    private let jsonEncoder = JSONEncoder()
    
    func trackEvent(_ event: TrackingEvent) {
        var request = URLRequest(url: TrackerDouble.serverURL)
        request.httpMethod = "POST"
        request.httpBody = try? jsonEncoder.encode(event)
        URLSession.shared.dataTask(with: request).resume()
    }
}

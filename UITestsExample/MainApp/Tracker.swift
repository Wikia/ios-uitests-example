//
//  Tracker.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import Foundation

class Tracker: TrackerProtocol {
    func trackEvent(_ event: TrackingEvent) {
        print ("Event fired: \(event)")
    }
}

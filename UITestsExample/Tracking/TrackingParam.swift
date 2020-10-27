//
//  TrackingParam.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import Foundation

enum TrackingParam: Hashable {
    case eventName
    case screen
    case custom(key: String)
}

extension TrackingParam: CodingKey {
    var stringValue: String {
        switch self {
        case .eventName:
            return "event_name"
        case .screen:
            return "screen"
        case let .custom(key):
            return key
        }
    }
    
    init(stringValue: String) {
        switch stringValue {
        case "event_name":
            self = .eventName
        case "screen":
            self = .screen
        default:
            self = .custom(key: stringValue)
        }
    }
    
    var intValue: Int? {
        nil
    }
    
    init?(intValue: Int) {
        nil
    }
}


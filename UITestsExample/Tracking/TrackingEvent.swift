//
//  TrackingEvent.swift
//  UITestsExample
//
//  Created by Rafał Kwiatkowski on 16/10/2020.
//

import Foundation

struct TrackingEvent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case name
        case params
    }
    
    let name: String
    let params: [TrackingParam: AnyHashable]
    
    init(name: String, params: [TrackingParam: AnyHashable] = [:]) {
        self.name = name
        self.params = params
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        let paramsContainer = try? container.nestedContainer(keyedBy: TrackingParam.self, forKey: .params)
        var newParams: [TrackingParam: AnyHashable] = [:]
        paramsContainer?.allKeys.forEach({ trackingParam in
            newParams[trackingParam] = (try? paramsContainer?.decode(String.self, forKey: trackingParam)) ??
                (try? paramsContainer?.decode(Int.self, forKey: trackingParam))
        })
        
        self.params = newParams
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var paramsContainer = container.nestedContainer(keyedBy: TrackingParam.self, forKey: .params)
        params.keys.forEach({ trackingParam in
            if let stringValue = params[trackingParam] as? String {
                try? paramsContainer.encode(stringValue, forKey: trackingParam)
            } else if let intValue = params[trackingParam] as? Int {
                try? paramsContainer.encode(intValue, forKey: trackingParam)
            }
        })
    }
}

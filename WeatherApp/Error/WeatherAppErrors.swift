//
//  WeatherAppErrors.swift
//  WeatherApp
//
//  Created by Julia Martsenko on 17.02.2022.
//

import Foundation

enum WeatherAppErrors: LocalizedError {
    case noSuchLocation
    case emptyRequest
    
    public var errorDescription: String? {
        switch self {
        case .noSuchLocation:
            return "Sorry, I didn't find your location, maybe you missed the planet, please specify a location on Earth and I will show you the weather in it."
        case .emptyRequest:
            return "Sorry, but I can't search for nothing. You doesn't value my time"
        }
    }
}

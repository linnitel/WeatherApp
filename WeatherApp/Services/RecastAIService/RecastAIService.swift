//
//  RecastAIService.swift
//  WeatherApp
//
//  Created by Julia Martsenko on 17.02.2022.
//

import Foundation
import RecastAI
import CoreLocation
import UIKit

protocol RecastAIServiceProtocol {
    func parceText(text: String, complition: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
}

final class RecastAIService: RecastAIServiceProtocol {
    
    lazy var recastAIClient = RecastAIClient(token: RECASTAI_TOKEN, language: LANGUAGE)
    
    func parceText(text: String, complition: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {

        let successHandler = { (_ response: Response) in
            DispatchQueue.global().async {
                guard let location = response.get(entity: "location"),
                      let latitude = location["lat"] as? CLLocationDegrees,
                      let longitude = location["lng"] as? CLLocationDegrees else {
                          complition(.failure(WeatherAppErrors.noSuchLocation))
                          return
                      }
                let searchLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                complition(.success(searchLocation))
            }
        }
        
        let failureHandle = { (_ error: Error) in
            complition(.failure(error))
        }

        recastAIClient.textRequest(text,
                                   token: RECASTAI_TOKEN,
                                   lang: LANGUAGE,
                                   successHandler: successHandler, failureHandle: failureHandle)
    }
}

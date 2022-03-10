//
//  DarkSkyService.swift
//  WeatherApp
//
//  Created by Julia Martsenko on 17.02.2022.
//

import Foundation
import ForecastIO
import CoreLocation

protocol DarkSkyServiceProtorol {
    func getWeather(in location: CLLocationCoordinate2D, complition: @escaping (Result<Forecast, Error>) -> Void)
}

class DarkSkyService: DarkSkyServiceProtorol {

    lazy var darkSkyClient = DarkSkyClient(apiKey: DARK_SKY_TOKEN)

    func getWeather(in location: CLLocationCoordinate2D, complition: @escaping (Result<Forecast, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            self.darkSkyClient.getForecast(location: location) { (result) in
                switch result {
                case .success((let forecast, _)):
                    complition(.success(forecast))
                case .failure(let error):
                    complition(.failure(error))
                }
            }
        }
    }
}

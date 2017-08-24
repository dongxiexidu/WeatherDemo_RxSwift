//
//  WeatherViewModel.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/22.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// enum 可以在class 里面或者外面
fileprivate enum WeatherDataEvent{
    case loading
    case weatherData(WeatherData)
    case error
}

class WeatherViewModel {
    
    // MARK: Output
    let locationName: Driver<String>
    let temperature: Driver<String>
    let realFeel: Driver<String>
    let precipitation: Driver<String>
    let updatedAt: Driver<String>
    
    let isLoading: Driver<Bool>
    let hasFailed: Driver<Bool>
    
    
    // MARK: Init 
    // 自定义init 方法,传入input流,以及工具类
    init(weatherDataService: WeatherDataService, refreshDriver: Driver<Void>) {
        let weatherDataEventDriver = refreshDriver
        .startWith(()) // 保证第一次运行一定会error 吗????
        .flatMapLatest { _ -> Driver<WeatherDataEvent> in
            return weatherDataService.fetchWeatherData()
                .map{ .weatherData($0) }
                .asDriver(onErrorJustReturn: .error)
                .startWith(.loading)
        }
        
        self.isLoading = weatherDataEventDriver
            .map{ event in
        
                switch event {
                case .loading :
                    return true
                default :
                    return false
                }
        }
        
        self.hasFailed = weatherDataEventDriver
            .map{ event in
        
                switch event {
                case .error :
                    return true
                default :
                    return false
                }
        }
        
        let weatherDataDriver = weatherDataEventDriver
            .map{ event -> WeatherData? in
        
                switch event {
                case .weatherData(let data):
                    return data
                default:
                    return nil
                }
            }
            .filter{ $0 != nil }
            .map{ $0! }
        
        self.locationName = weatherDataDriver.map{ $0.locationName }
        self.temperature = weatherDataDriver.map { String(format: "%.1f\u{00B0}C", $0.temperature) }
        self.realFeel = weatherDataDriver.map { String(format: "%.1f\u{00B0}C", $0.realFeel) }
        self.precipitation = weatherDataDriver.map { String(format: "%.0f%%", $0.precipitation) }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.updatedAt = weatherDataDriver.map { dateFormatter.string(from: $0.updatedAt) }
        
    }
    
}

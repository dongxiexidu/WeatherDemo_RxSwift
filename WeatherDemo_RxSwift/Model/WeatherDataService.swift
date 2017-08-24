//
//  WeatherDataService.swift
//  WeatherDemo_RxSwift
//
//  Created by fashion on 2017/8/22.
//  Copyright © 2017年 shangZhu. All rights reserved.
//

import Foundation
import RxSwift


open class WeatherDataService {
    
    // 1. create 自定义观察序列 返回的WeatherData 类型流
     func fetchWeatherData() -> Observable<WeatherData> {
        let observable = Observable<WeatherData>.create { [weak self] observer in
            if let weakSelf = self{
                let time = 0.5 + TimeInterval(arc4random_uniform(10)) / 10.0
                
                // 主线程延迟处理,模拟网络请求数据
                DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: { 
                    let shouldFail = arc4random_uniform(2) == 0
                    if shouldFail {
                        observer.onError(NSError(domain:"Fake network error", code: 0, userInfo: nil))
                    }else{
                        observer.onNext(weakSelf.createRandomWeatherData())
                        observer.onCompleted()
                    }
                    
                })
            }
            return Disposables.create() // 固定写法,记住 需实现.onError() .onNext .onCompleted
        }
        return observable.shareReplay(1)
    }
    
    
    fileprivate func createRandomWeatherData() -> WeatherData {
        
        let subtractTime = -1 * TimeInterval(arc4random_uniform(3600))
        let date = Date().addingTimeInterval(subtractTime)
        
        let temperature = -20 + Float(arc4random_uniform(400)) / 10.0
        
        let tempDiff = -8 + Float(arc4random_uniform(160)) / 10.0
        let realFeel = temperature + tempDiff
        
        let precipitation = Float(arc4random_uniform(101))
        
        // 2.结构体模型创建
        let weatherData = WeatherData(locationName: "Osijek", temperature: temperature, realFeel: realFeel, precipitation: precipitation, updatedAt: date)
        
        return weatherData
    }
}

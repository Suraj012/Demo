//
//  DataStore.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

public protocol LocalDataStore: class {
    func storeCityData(cityData: [CityRPElement], completion: ResultCallback<[CityRPElement]>?)
    func fetchCityData(completion: ResultCallback<[CityRPElement]>?)
    func getCityData() -> [CityRPElement]?
    func storeFoodData(foodData: [FoodRPElement], completion: ResultCallback<[FoodRPElement]>?)
    func fetchFoodData(completion: ResultCallback<[FoodRPElement]>?)
    func getFoodData() -> [FoodRPElement]?
}


class LocalDataStorageClass: LocalDataStore {
    
    private let cityCache: Cache<[CityRPElement]>
    private var city: [CityRPElement]?
    
    private let foodCache: Cache<[FoodRPElement]>
    private var food: [FoodRPElement]?
    
    
    public init() {
        self.cityCache = Cache<[CityRPElement]>(path: Bundle.main.bundleIdentifier ?? "\(LocalDataStorageClass.self)")
        self.foodCache = Cache<[FoodRPElement]>(path: Bundle.main.bundleIdentifier ?? "\(LocalDataStorageClass.self)")
    }
    
    func storeCityData(cityData: [CityRPElement], completion: ResultCallback<[CityRPElement]>? = nil) {
        cityCache.save(object: cityData) { (result) in
            switch result {
            case .success(let cityData):
                self.city = cityData
                completion?(.success(cityData))
            case .failure(let aError):
                completion?(.failure(aError))
            }
        }
    }
    
    func fetchCityData(completion: ResultCallback<[CityRPElement]>? = nil) {
        cityCache.fetch { [weak self] (result) in
            switch result {
            case .success(let cityData):
                self?.city = cityData
                completion?(.success(cityData))
            case .failure(let aError):
                completion?(.failure(aError))
            }
        }
    }
    
    func getCityData() -> [CityRPElement]? {
        if city == nil {
            cityCache.fetch { [weak self] (result) in
                switch result {
                case .success(let cityData):
                    self?.city = cityData
                case .failure(_):
                    break
                }
            }
            return city
        } else {
            return city
        }
    }
    
    func storeFoodData(foodData: [FoodRPElement], completion: ResultCallback<[FoodRPElement]>? = nil) {
        foodCache.save(object: foodData) { (result) in
            switch result {
            case .success(let foodData):
                self.food = foodData
                completion?(.success(foodData))
            case .failure(let aError):
                completion?(.failure(aError))
            }
        }
    }
    
    func fetchFoodData(completion: ResultCallback<[FoodRPElement]>? = nil) {
        foodCache.fetch { [weak self] (result) in
            switch result {
            case .success(let foodData):
                self?.food = foodData
                completion?(.success(foodData))
            case .failure(let aError):
                completion?(.failure(aError))
            }
        }
    }
    
    func getFoodData() -> [FoodRPElement]? {
        if city == nil {
            foodCache.fetch { [weak self] (result) in
                switch result {
                case .success(let foodData):
                    self?.food = foodData
                case .failure(_):
                    break
                }
            }
            return food
        } else {
            return food
        }
    }
}


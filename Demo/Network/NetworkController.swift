//
//  NetworkController.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

class NetworkController {
    private let apiClient: APIClient
    private let dataStorage: LocalDataStore
       
    init() {
        self.apiClient = DefaultAPIClient()
        self.dataStorage = LocalDataStorageClass()
    }
    
    func getCityList(completion: @escaping ResultCallback<[CityRPElement]>) {
        self.apiClient.send(nil as String?, path: WebService.cityList) { (status) in
            switch status {
            case .success(let data):
                guard let response = try? data.decode(to: CityRP.self) else {
                    completion(.failure(APIError.decoding))
                    return
                }
                self.dataStorage.storeCityData(cityData: response, completion: { (result) in
                    switch result {
                    case .success:
                        completion(.success(response))
                    case .failure(let aError):
                        completion(.failure(aError))
                    }
                })
//                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getFoodList(completion: @escaping ResultCallback<[FoodRPElement]>) {
        self.apiClient.send(nil as String?, path: WebService.foodList) { (status) in
            switch status {
            case .success(let data):
                guard let response = try? data.decode(to: FoodRP.self) else {
                    completion(.failure(APIError.decoding))
                    return
                }
                self.dataStorage.storeFoodData(foodData: response, completion: { (result) in
                    switch result {
                    case .success:
                        completion(.success(response))
                    case .failure(let aError):
                        completion(.failure(aError))
                    }
                })
//                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

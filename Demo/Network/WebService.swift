//
//  WebService.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

public class WebService {
    
    public static var shared: WebService {
        return singleton
    }
    
    private static let singleton: WebService = WebService()
    
    public static var baseUrl: String {
        return "https://api.npoint.io/"
    }
    
    public static var cityList: String {
        return "e81570e822b273f0a366"
    }
    public static var foodList: String {
        return "b4dd0d44343f7eb08f9c"
    }
}


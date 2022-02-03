//
//  FoodSP.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

// MARK: - FoodSPElement
public struct FoodRPElement: Codable {
    let name: String
    let image: String
}

typealias FoodRP = [FoodRPElement]

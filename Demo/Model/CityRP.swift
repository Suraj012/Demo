//
//  CitySP.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

// MARK: - CitySPElement
public struct CityRPElement: Codable {
    let name: String
    let image: String
    let cityRPDescription: String

    enum CodingKeys: String, CodingKey {
        case name, image
        case cityRPDescription = "description"
    }
}

typealias CityRP = [CityRPElement]

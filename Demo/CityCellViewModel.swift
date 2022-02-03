//
//  CityCellViewModel.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import UIKit

struct CityCellViewModel {
    
    let image: String?
    let name: String?
    let description: String?
        
    init(data: CityRPElement) {
        self.image = data.image
        self.name = data.name.capitalizingFirstLetter()
        self.description = data.cityRPDescription
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//
//  FoodCellViewModel.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import UIKit

struct FoodCellViewModel {
    
    let image: String?
    let name: String?
        
    init(data: FoodRPElement) {
        self.image = data.image
        self.name = data.name.capitalizingFirstLetter()
    }
}

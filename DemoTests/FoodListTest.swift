//
//  FoodListTest.swift
//  DemoTests
//
//  Created by inficare on 03/02/2022.
//

import XCTest
@testable import Demo

class FoodListTest: XCTestCase {

    func test_FoodListResponse(){

            // ARRANGE
            let network = NetworkController()
            let expectation = self.expectation(description: "FoodListResponse")

            // ACT
            network.getFoodList(completion: {(data) in
                switch data {
                case .success(let response):
                    // ASSERT
                    XCTAssertNotNil(response)
                    XCTAssertTrue(response.count != 0)
                case .failure(let aError):
                    // ASSERT
                    XCTAssertNotNil(aError.description)
                }
                expectation.fulfill()
            })
            waitForExpectations(timeout: 10, handler: nil)
        }

}

//
//  City.swift
//  MKTFU
//
//  Created by mac on 2023-03-23.
//

import Foundation

//MARK: - CityListTest
class CityListTest: Codable {
    let status: String
    let error: [String]?
    let data: [CityListDataTest]
    
    init() {
        self.status = ""
        self.error = [""]
        self.data = [CityListDataTest]()
    }

    init(status: String, error: [String], data: [CityListDataTest]) {
        self.status = status
        self.error = error
        self.data = data
    }
}

// MARK: - CityListDataTest
class CityListDataTest: Codable {
    let cityID, name: String
    
    init() {
        self.cityID = ""
        self.name = ""
    }

    init(cityID: String, name: String) {
        self.cityID = cityID
        self.name = name
    }
}

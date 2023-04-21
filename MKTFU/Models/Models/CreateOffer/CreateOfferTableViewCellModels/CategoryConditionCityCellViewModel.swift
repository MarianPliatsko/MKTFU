//
//  CategoryConditionCityCellViewModel.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct CategoryConditionCityCellViewModel {
    var title: String
    var placeholder: String
    var text: String
    var rawValue: String
    var categories: [String]
    var textInView: ((String) -> Void)
    var onButtonPressed: (() -> Void)
}

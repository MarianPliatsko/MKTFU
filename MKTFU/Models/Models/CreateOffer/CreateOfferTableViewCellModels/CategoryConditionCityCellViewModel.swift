//
//  CategoryConditionCityCellViewModel.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct CategoryConditionCityCellViewModel {
    let title: String
    let placeholder: String
    let text: String
    let rawValue: String
    let pickerItems: [PickerItem]
    let isDisabled: Bool
    let textInView: ((String) -> Void)
    let onButtonPressed: (() -> Void)
}

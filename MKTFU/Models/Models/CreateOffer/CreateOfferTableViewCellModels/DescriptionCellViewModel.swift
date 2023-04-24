//
//  DescriptionCellViewModel.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct DescriptionCellViewModel {
    let title: String
    let text: String
    let isDisabled: Bool
    let descriptionTextInView: ((String) -> Void)
}

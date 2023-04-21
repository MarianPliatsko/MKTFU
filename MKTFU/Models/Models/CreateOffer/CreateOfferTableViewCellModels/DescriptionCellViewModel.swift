//
//  DescriptionCellViewModel.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct DescriptionCellViewModel {
    var title: String
    var text: String
    var descriptionTextInView: ((String) -> Void)
}

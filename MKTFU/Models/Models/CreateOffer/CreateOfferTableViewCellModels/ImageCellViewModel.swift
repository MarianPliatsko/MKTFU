//
//  CreateOfferTableViewCellModels.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct ImageCellViewModel {
    var images: [String]
    var onAddImageButtonTapped: (() -> Void)
    var onDeletePressed: ((String?) -> Void)
}

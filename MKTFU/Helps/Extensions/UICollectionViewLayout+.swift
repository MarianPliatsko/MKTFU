//
//  UICollectionViewLayout+.swift
//  MKTFU
//
//  Created by mac on 2023-04-23.
//

import Foundation
import UIKit

extension UICollectionViewCompositionalLayout {
     static func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = CompositionLayout.createItem(width: .fractionalWidth(1),
                                                height: .fractionalHeight(1),
                                                spacing: 0)
        
        let group = CompositionLayout.createGroup(alignment: .horizontal,
                                                  width: .fractionalWidth(1),
                                                  height: .fractionalHeight(1),
                                                  item: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
         return UICollectionViewCompositionalLayout(section: section)
    }
}

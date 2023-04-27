//
//  UICollectionViewLayout+.swift
//  MKTFU
//
//  Created by mac on 2023-04-23.
//

import Foundation
import UIKit

extension UICollectionViewCompositionalLayout {
    static func createLayout(itemWidth: NSCollectionLayoutDimension,
                             itemHeight: NSCollectionLayoutDimension,
                             groupWidth: NSCollectionLayoutDimension,
                             groupHeight: NSCollectionLayoutDimension) -> UICollectionViewCompositionalLayout {
        
        let item = CompositionLayout.createItem(width: itemWidth,
                                                height: itemHeight,
                                                spacing: 0)
        
        let group = CompositionLayout.createGroup(alignment: .horizontal,
                                                  width: groupWidth,
                                                  height: groupHeight,
                                                  item: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
         return UICollectionViewCompositionalLayout(section: section)
    }
}



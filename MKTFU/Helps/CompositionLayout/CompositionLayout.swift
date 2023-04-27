//
//  CompositionLayout.swift
//  MKTFU
//
//  Created by mac on 2023-02-14.
//

import UIKit

class CompositionLayout {
    static func createItem(width: NSCollectionLayoutDimension,
                           height: NSCollectionLayoutDimension,
                           spacing: CGFloat) -> NSCollectionLayoutItem {
        
        let item = NSCollectionLayoutItem(layoutSize:NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                     leading: spacing,
                                                     bottom: spacing,
                                                     trailing: spacing)
        return item
    }
    
    static func createGroup(alignment: CompositionalGroupAlignment,
                            width: NSCollectionLayoutDimension,
                            height: NSCollectionLayoutDimension,
                            items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                   heightDimension: height),
                subitems: items)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                   heightDimension: height),
                subitems: items)
        }
    }
    
    static func createGroup(alignment: CompositionalGroupAlignment,
                            width: NSCollectionLayoutDimension,
                            height: NSCollectionLayoutDimension,
                            item: NSCollectionLayoutItem,
                            count: Int) -> NSCollectionLayoutGroup {
        switch alignment {
        case .vertical:
            return NSCollectionLayoutGroup.vertical(
                layoutSize:
                    NSCollectionLayoutSize(widthDimension: width,
                                           heightDimension: height),
                repeatingSubitem: item,
                count: count)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                   heightDimension: height),
                repeatingSubitem: item,
                count: count)
        }
    }
}

//
//  HistoryCollectionViewLayout.swift
//  medR
//
//  Created by Rui Ong on 03/03/2017.
//  Copyright © 2017 Kok Yong. All rights reserved.
//

import UIKit

class HistoryCollectionViewLayout: UICollectionViewLayout {
    
    let cellHeight = Double(UIScreen.main.bounds.size.height - 150)
    let cellWidth = Double(UIScreen.main.bounds.size.width)
    
    var cellAttrDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    
    override func prepare() {
        if let validSectionCount = collectionView?.numberOfSections {
            if validSectionCount > 0 {
                for section in 0..<validSectionCount{
                    if let validItemCount = collectionView?.numberOfItems(inSection: section){
                        if validItemCount > 0 {
                            for item in 0..<validItemCount {
                                
                                let cellIndexPath = IndexPath(item: item, section: section)
                                
                                let xPos = Double(item) * cellWidth
                                let yPos = Double(section) * cellHeight
                                
                                var cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
                                cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                                cellAttributes.zIndex = 1
                                
                                cellAttrDictionary[cellIndexPath] = cellAttributes
                                
                                contentSize = CGSize(width: cellAttributes.frame.maxX, height: cellAttributes.frame.maxY)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.cellAttrDictionary.count > 0 {
            for (_, value) in self.cellAttrDictionary {
                
                
                //what is this??
                if rect.contains(value.frame) {
                    attributes.append(value)
                }
            }
        }
        
        return attributes
        
    }
    
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cellAttrDictionary[indexPath]
        
    }
}

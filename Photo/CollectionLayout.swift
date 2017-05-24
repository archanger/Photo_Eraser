//
//  CollectionLayout.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit

class CollectionLayout: UICollectionViewLayout {
  
  var columns = 3
  var cellPadding: CGFloat = 4
  
  override func prepare() {
    if _cache.isEmpty {
    
      
      var xOffset: CGFloat = 0
      let width = collectionView!.bounds.width
      
      for itemIndex in 0..<collectionView!.numberOfItems(inSection: 0) {
        
        let indexPath = IndexPath(item: itemIndex, section: 0)
        
        var frame = CGRect(x: xOffset, y: 0, width: width, height: contentHeight)
        frame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame
        _cache.append(attributes)
        
        xOffset += width
        
      }
      
      contentWidth = CGFloat(collectionView!.numberOfItems(inSection: 0)) * width
      
    
//      let columnWidth = contentWidth / CGFloat(columns)
//      var xOffset = [CGFloat]()
//      for column in 0..<columns {
//        xOffset.append(CGFloat(column) * columnWidth)
//      }
//      
//      var column = 0
//      var yOffset = Array<CGFloat>(repeating: 0, count: columns)
//      
//      for item in 0..<collectionView!.numberOfItems(inSection: 0) {
//        
//        let indexPath = IndexPath(item: item, section: 0)
//        
//        let height = columnWidth
//        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
//        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
//        
//        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//        attributes.frame = insetFrame
//        _cache.append(attributes)
//        
//        contentHeight = max(contentHeight, frame.maxY)
//        yOffset[column] = yOffset[column] + height
//        
//        column = (column + 1) % columns
//      }
//      
    }
  }
  
  override func invalidateLayout() {
    super.invalidateLayout()
    
    _cache.removeAll()
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var attrs = [UICollectionViewLayoutAttributes]()
    
    for attr in _cache{
      if attr.frame.intersects(rect) {
        attrs.append(attr)
      }
    }
    
    return attrs
  }
  
  private var contentHeight: CGFloat {
    let insets = collectionView!.contentInset
    return collectionView!.bounds.height - (insets.top + insets.bottom)
  }
  private var contentWidth: CGFloat = 0
  
  private var _cache = [UICollectionViewLayoutAttributes]()
}

//
//  PhotoAssetCacheService.swift
//  Photo
//
//  Created by Kirill on 23.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit
import Photos

protocol PhotoAssetCacheServiceProtocol {
  
  func clear()
  func warmup(with ids: [String])
  func image(for id: String, completion: @escaping (UIImage?) -> Void)
  
}


class PhotoAssetCacheService: PhotoAssetCacheServiceProtocol {
  func clear() {
    _cahce.removeAll()
  }
  
  func warmup(with ids: [String]) {
    
    let result = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil)
    
    var assets: [PHAsset] = []
    result.enumerateObjects({ (asset, index, _) in
      assets.append(asset)
    })

  }
  
  func image(for id: String, completion: @escaping (UIImage?) -> Void) {
    
    if _cahce[id] != nil {
      completion(_cahce[id])
    } else {
      if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).lastObject {
      
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        
        _imageManager.requestImage(
          for: asset,
          targetSize: CGSize(width: 300, height: 500),
          contentMode: .aspectFit,
          options: nil,
          resultHandler: { [weak self] (image, info) in
            self?._cahce[id] = image
            completion(image)
        })
      }
    }
    
  }
  
  private var _cahce: [String: UIImage] = [:]
  private var _imageManager = PHImageManager.default()
}

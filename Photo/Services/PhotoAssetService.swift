//
//  PhotoService.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import Photos

class PhotoAssetService {
  
  func requestAuth(completion: @escaping (_ success:Bool) -> Void){
    
    if PHPhotoLibrary.authorizationStatus() == .authorized {
      completion(true)
    } else {
      PHPhotoLibrary.requestAuthorization({ (status) in
        DispatchQueue.main.async {
          completion(status == PHAuthorizationStatus.authorized)
        }
      })
    }
  }
  
  func fetchPhotos(from date: Date = Date.init(timeIntervalSince1970: 0), completion: @escaping ([Photo]) -> Void) {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "creationDate > %@", argumentArray: [date])
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    let assets = PHAsset.fetchAssets(with: .image, options: options)
    var photos: [Photo] = []
    
    assets.enumerateObjects({ (asset, v, w) in
      photos.append(Photo(from: asset))
    })
    
    completion(photos)
  }
  
  
  
  func fetchAsset(by id: String, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
    fetchAssets(by: [id], completion: completion)
  }
  
  func fetchAssets(by ids: [String], completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
    completion(PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil))
  }
}

extension Photo {
  convenience init(from asset: PHAsset) {
    self.init(identifier: asset.localIdentifier, date: asset.creationDate ?? Date())
  }
}

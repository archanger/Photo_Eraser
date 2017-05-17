//
//  PhotoService.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import Photos

class PhotoService {
  
  func requestAuth(completion: @escaping (_ success:Bool) -> Void){
    
    if PHPhotoLibrary.authorizationStatus() == .authorized {
      completion(true)
    } else {
      PHPhotoLibrary.requestAuthorization({ (status) in
        completion(status == PHAuthorizationStatus.authorized)
      })
    }
  }
  
  func fetchAssets(completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
    let options = PHFetchOptions()
    options.fetchLimit = 100
    completion(PHAsset.fetchAssets(with: options))
  }
  
  func fetchAsset(by id: String, completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
    fetchAssets(by: [id], completion: completion)
  }
  
  func fetchAssets(by ids: [String], completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
    completion(PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil))
  }
}

//
//  PhotoService.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit
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
//    options.predicate = NSPredicate(format: "creationDate > %@", argumentArray: [date])
    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    let assets = PHAsset.fetchAssets(with: .image, options: options)
    var photos: [Photo] = []
    
    var idsToWarmUp: [String] = []
    assets.enumerateObjects({ (asset, v, w) in
      photos.append(Photo(from: asset))
      idsToWarmUp.append(asset.localIdentifier)
    })
    
    
    _cache.clear()
    _cache.warmup(with: idsToWarmUp)
    
    completion(photos)
  }
  
  func fetchThumbImage(by id: String, completion: @escaping (UIImage?) -> Void) {

    _cache.image(for: id, completion: completion)
    
  }
  
  func fetchOriginImage(by id: String, completion: @escaping (UIImage?) -> Void) {
    if let asset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).lastObject {
      
      let cache_options = PHImageRequestOptions()
      cache_options.isNetworkAccessAllowed = true
      _imageManager.requestImage(
        for: asset,
        targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
        contentMode: .aspectFit,
        options: cache_options,
        resultHandler: { (image, info) in
          completion(image)
      })
      
    } else {
      completion(nil)
    }
  }
  
//  func fetchAsset(by id: String, completion: @escaping (Photo?) -> Void) {
//    fetchAssets(by: [id], completion: completion)
//  }
//  
//  func fetchAssets(by ids: [String], completion: @escaping (Photo?) -> Void) {
//    let asset = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil).lastObject
//    if let asset = asset {
//      let cache_options = PHImageRequestOptions()
//      cache_options.isNetworkAccessAllowed = true
//      _imageManager.startCachingImages(
//        for: [asset],
//        targetSize: CGSize(width: 200, height: 200),
//        contentMode: .aspectFit,
//        options: cache_options
//      )
//      completion(Photo(from: asset))
//    } else {
//      completion(nil)
//    }
//  }
  
  func delete(photos: [Photo], completion: @escaping (Error?) -> Void) {
    
    PHPhotoLibrary.shared().performChanges({ 
      let assets = PHAsset.fetchAssets(withLocalIdentifiers: photos.map({ $0.identifier }), options: nil)
      PHAssetChangeRequest.deleteAssets(assets)
    }) { (success, error) in
      print("Done: \(success)\nError: \(error?.localizedDescription ?? "")")
      completion(error)
    }
  }
  
  deinit {
    _imageManager.stopCachingImagesForAllAssets()
  }
  
  private var _imageManager = PHCachingImageManager()
  private var _cache = PhotoAssetCacheService()
}

extension Photo {
  convenience init(from asset: PHAsset) {
    self.init(identifier: asset.localIdentifier, date: asset.creationDate ?? Date())
  }
}

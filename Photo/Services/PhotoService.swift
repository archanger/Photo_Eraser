//
//  PhotoService.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit

class PhotoService {
  
  init() {
    
    _assetService = PhotoAssetService()
    _infoService = InfoDbService(manager: DataBaseManager.instance!)
    _dbService = PhotoDbService(manager: DataBaseManager.instance!, infoService: _infoService)
    
  }
  
  func requestAuth(completion: @escaping (_ success:Bool) -> Void) {
    _assetService.requestAuth(completion: completion)
  }
  
  func update() {
    
    let lastDate = _infoService.fetchLastDate()
    _assetService.fetchPhotos(from: lastDate, completion: _dbService.updateDB(with:))
  }
  
  
  func requestImage(for id: String, completion: @escaping (UIImage?) -> Void) {
    _assetService.fetchThumbImage(by: id, completion: completion)
  }
  
  func requestImage(for photo: Photo, completion: @escaping (UIImage?) -> Void) {
    requestImage(for: photo.identifier, completion: completion)
  }
  
  func fetchPhotos(completion: @escaping ([Photo]) -> Void) {
    let photo = _dbService.fetchBatchOfNotShownPhoto()
    completion(photo)
  }
  
  func remove(photos: [Photo], completion: @escaping (Bool) -> Void) {
    _assetService.delete(photos: photos) { error in
      if error == nil {
        self._dbService.delete(photos: photos)
      }
      completion(error == nil)
    }
  }
  
  func update(photos: [Photo]) {
    _dbService.update(photos: photos)
  }
  
  private var _assetService: PhotoAssetService
  private var _dbService: PhotoDbService
  private var _infoService: InfoDbService
}

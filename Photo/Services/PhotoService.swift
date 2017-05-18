//
//  PhotoService.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation

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
    _assetService.fetchPhotos(from: lastDate, completion: _dbService.insert(photos:))
    
  }
  
  private var _assetService: PhotoAssetService
  private var _dbService: PhotoDbService
  private var _infoService: InfoDbService
}

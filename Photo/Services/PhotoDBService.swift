//
//  PhotoDBService.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import CoreData

class PhotoDbService {
  
  init(manager: DataBaseManager, infoService: InfoDbService) {
    _manager = manager
    _infoService = infoService
  }
  
  func insert(photos: [Photo]) {
    
    guard photos.count > 0 else {
      return
    }
    
    _manager.makeTransaction { (context) in
      for photo in photos {
        let dbp = NSEntityDescription.insertNewObject(forEntityName: "DBPhoto", into: context) as! DBPhoto
        dbp.update(with: photo)
      }
    }
    
    let lastDate = photos.last!.createdDate
    _infoService.update(date: lastDate)
  }
  
  func update(photos: [Photo]) {
    
  }
  
  func delete(photos: [Photo]) {
    
  }
  
  private var _manager: DataBaseManager
  private var _infoService: InfoDbService
}

class InfoDbService {
  
  init(manager: DataBaseManager) {
    _manager = manager
  }
  
  func fetchLastDate() -> Date {
    
    var date: Date?
    _manager.makeTransaction { (context) in
      let info = checkExistance(context)
      date = info.lastPhotoDate! as Date
    }
    
    return date!
  }
  
  func update(date: Date) {
    _manager.makeTransaction { (context) in
      let info = checkExistance(context)
      info.lastPhotoDate = date as NSDate
    }
  }
  
  func fetchPhotoCount() -> Int16 {
    var count: Int16 = 0
    _manager.makeTransaction { (context) in
      let info = checkExistance(context)
      count = info.numberToShow
    }
    
    return count
  }
  
  func updatePhotoCount(_ count: Int16) {
    _manager.makeTransaction { (context) in
      let info = checkExistance(context)
      info.numberToShow = count
    }
  }
  
  private func checkExistance(_ context: NSManagedObjectContext) -> DBInfo {
    let request: NSFetchRequest<DBInfo> = DBInfo.fetchRequest()
    
    let result = try! context.fetch(request)
    if result.count == 0 {
      let info = NSEntityDescription.insertNewObject(forEntityName: "DBInfo", into: context) as! DBInfo
      info.lastPhotoDate = Date(timeIntervalSince1970: 0) as NSDate
      info.numberToShow = 10
      return info
    }
    return result.first!
  }
  
  private var _manager: DataBaseManager
}

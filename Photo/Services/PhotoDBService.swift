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
  
  func fetchBatchOfNotShownPhoto() -> [Photo] {
    
    let photoTotal = _infoService.fetchTotalNotShownPhoto()
    let numberToResponse = Int(_infoService.fetchPhotoCount())
    var offset = 0
    if photoTotal > numberToResponse {
      offset = Int(arc4random_uniform(UInt32(photoTotal - numberToResponse)))
    }
    
    let request: NSFetchRequest<DBPhoto> = DBPhoto.fetchRequest()
    request.fetchOffset = offset
    request.fetchLimit = Int(numberToResponse)
    request.predicate = NSPredicate(format: "shown == %@", argumentArray: [false])
    
    var res: [Photo] = []
    
    _manager.makeTransaction { (context) in
      let result = try! context.fetch(request)
      for photo in result {
        res.append(Photo(from: photo))
      }
    }
    
    return res
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
    
    _manager.makeTransaction { (context) in
      
      for photo in photos {
        
        let request: NSFetchRequest<DBPhoto> = DBPhoto.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", argumentArray: [photo.identifier])
        
        let res = try! context.fetch(request)
        if res.count == 1, let db = res.first {
          
          db.identifier = photo.identifier
          db.shown = photo.shown
          db.dateCreated = photo.createdDate as NSDate
          
        }
        
      }
      
    }
    
  }
  
  func delete(photos: [Photo]) {
    
    _manager.makeTransaction { (context) in
      
      let request: NSFetchRequest<DBPhoto> = DBPhoto.fetchRequest()
      request.predicate = NSPredicate(format: "identifier IN %@", argumentArray: [photos.map({ $0.identifier })])
      
      let res = try! context.fetch(request)
      for photo in res {
        context.delete(photo)
      }
    }
    
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
  
  func fetchTotalNotShownPhoto() -> Int {
    
    var count: Int = 0
  
    _manager.makeTransaction { (context) in
      
      let request: NSFetchRequest<DBPhoto> = DBPhoto.fetchRequest()
      request.resultType = .countResultType
      request.predicate = NSPredicate(format: "shown == %@", argumentArray: [false])
      let result = try! context.count(for: request)
      count = result
    }
    
    return count
  }
  
  private func checkExistance(_ context: NSManagedObjectContext) -> DBInfo {
    let request: NSFetchRequest<DBInfo> = DBInfo.fetchRequest()
    
    let result = try! context.fetch(request)
    if result.count == 0 {
      let info = NSEntityDescription.insertNewObject(forEntityName: "DBInfo", into: context) as! DBInfo
      info.lastPhotoDate = Date(timeIntervalSince1970: 0) as NSDate
      info.numberToShow = 100
      return info
    }
    return result.first!
  }
  
  private var _manager: DataBaseManager
}

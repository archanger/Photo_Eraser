//
//  DBManger.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager {
  
  static var instance: DataBaseManager? = DataBaseManager()
  
  func makeTransaction(_ transaction: (NSManagedObjectContext) -> Void) {
    
    transaction(_context)
    if _context.hasChanges {
      do {
        try _context.save()
      } catch {
        print("Error: \(error.localizedDescription)")
      }
    }
    
  }
  
  private init?() {
    
    if let url = Bundle.main.url(forResource: "Photo", withExtension: "momd"),
       let mom = NSManagedObjectModel(contentsOf: url) {
      _managedObjectModel = mom
      _storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
      
      
      _context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
      _context.persistentStoreCoordinator = _storeCoordinator
    
      do {
        try _storeCoordinator.addPersistentStore(
          ofType: NSSQLiteStoreType,
          configurationName: nil,
          at: _storeUrl,
          options: nil
        )
      } catch {
        return nil
      }
    } else {
      return nil
    }
  }
  
  private lazy var _storeUrl: URL? = {
    var fm = FileManager.default
    let docURL = fm.urls(for: .documentDirectory, in: .userDomainMask).last
    return docURL?.appendingPathComponent("db.sqlite")
  }()
  
  private var _context: NSManagedObjectContext
  private var _storeCoordinator: NSPersistentStoreCoordinator
  private var _managedObjectModel: NSManagedObjectModel
}

extension Photo {
  convenience init(from db: DBPhoto) {
    self.init(identifier: db.identifier ?? "", date: (db.dateCreated as Date?) ?? Date(), shown: db.shown)
  }
}

extension DBPhoto {
  func update(with photo: Photo) {
    self.identifier = photo.identifier
    self.dateCreated = photo.createdDate as NSDate
    self.shown = photo.shown
  }
}

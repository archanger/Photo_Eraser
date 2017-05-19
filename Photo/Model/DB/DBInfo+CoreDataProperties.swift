//
//  DBInfo+CoreDataProperties.swift
//  Photo
//
//  Created by Kirill on 19.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation
import CoreData


extension DBInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBInfo> {
        return NSFetchRequest<DBInfo>(entityName: "DBInfo")
    }

    @NSManaged public var lastPhotoDate: NSDate?
    @NSManaged public var numberToShow: Int16
    @NSManaged public var photosCount: Int64

}

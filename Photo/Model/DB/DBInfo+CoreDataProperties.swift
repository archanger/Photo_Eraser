//
//  DBInfo+CoreDataProperties.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
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

}

//
//  Photo.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation

class Photo {
  let identifier: String
  let createdDate: Date
  var shown: Bool
  init(identifier: String, date: Date, shown: Bool = false) {
    self.identifier = identifier
    self.createdDate = date
    self.shown = shown
  }
}

//
//  ImportSource.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import Foundation

class ImportSource {
  
  init() {
    _service = PhotoService()
  }
  
  func update() {
    
    _service.requestAuth(completion: onRequestCompletion(status:))
  }
  
  private func onRequestCompletion(status: Bool) {
    guard status == true else {
      print("Сам дурак")
      return
    }
    
    _service.update()
  }
  
  private var _service: PhotoService
}

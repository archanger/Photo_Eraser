//
//  ImportViewController.swift
//  Photo
//
//  Created by Kirill on 18.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    _source.update()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  private var _source = ImportSource()
}

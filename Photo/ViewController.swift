//
//  ViewController.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    _collectionView.dataSource = _dataSource
    _collectionView.delegate = _dataSource
  }
  
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBOutlet fileprivate weak var _collectionView: UICollectionView!
  private var _dataSource = ImageSource()
}

extension ViewController: ImageSourceOutupt {
  func reload() {
    self._collectionView.reloadData()
  }
}

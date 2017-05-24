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
    
    _dataSource.output = self
    
    navigationController?.setNavigationBarHidden(false, animated: false)
    navigationItem.hidesBackButton = true
    
    _collectionView.dataSource = _dataSource
    _collectionView.delegate = _dataSource
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    _collectionView.collectionViewLayout.invalidateLayout()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBOutlet weak var _keepButton: UIButton!
  @IBOutlet weak var _deleteButton: UIButton!
  
  @IBAction func _removeCurrent() {
    _dataSource.deleteCurrent()
  }
  
  @IBAction func _keepCurrent() {
    _dataSource.keepCurrent()
  }

  @IBAction func deleteAction(_ sender: UIBarButtonItem) {
    _dataSource.deleteSelected()
  }
  @IBAction func refreshAction(_ sender: Any) {
    _dataSource.fetchNewBatch()
  }

  @IBOutlet fileprivate weak var _trashButton: UIBarButtonItem! {
    didSet {
      _trashButton.isEnabled = false
    }
  }
  @IBOutlet fileprivate weak var _collectionView: UICollectionView!
  private var _dataSource = ImageSource()
}

extension ViewController: ImageSourceOutupt {
  func reload() {
    self._collectionView.reloadData()
    self._collectionView.collectionViewLayout.invalidateLayout()
  }
  
  func canRemove(_ yesNo: Bool) {
    _trashButton.isEnabled = yesNo
  }
  
  func interaction(started: Bool) {
    _keepButton.isEnabled = !started
    _deleteButton.isEnabled = !started
  }
}

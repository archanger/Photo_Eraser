//
//  ImageSource.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit
import Photos

protocol ImageSourceOutupt: class {
  func reload()
  func canRemove(_ yesNo: Bool)
  func interaction(started: Bool)
}

class ImageSource: NSObject {

  weak var output: ImageSourceOutupt?
  
  override init() {
    super.init()
    
    _photoService.requestAuth(completion: onRequestCompletion(status:))
  }
  
  func deleteSelected() {
    _photoService.remove(photos: _modelsToDelete.map({ $0.value })) { success in
      if success == true {
        DispatchQueue.main.async {
          self.onRequestCompletion(status: true)
        }
      }
    }
  }
  
  func deleteCurrent() {
    print("Current item(\(_currentModelIndex)) deleted")
  }
  
  func keepCurrent() {
    print("Current item(\(_currentModelIndex)) kept")
  }
  
  func fetchNewBatch() {
    onRequestCompletion(status: true)
  }
  
  private func onRequestCompletion(status: Bool) {
    guard status == true else {
      print("Сам дурак")
      return
    }
    
    _models.forEach({ $0.shown = true })
    _photoService.update(photos: _models)
    
    _photoService.fetchPhotos { (result) in
      self.prepareData(assets: result);
    }
  }
  
  private func prepareData(assets: [Photo]) {
  
    _models = assets
    _modelsToDelete.removeAll()
    self.output?.reload()
    output?.canRemove(false)
  }
  
  fileprivate func _imageCellModel(from photo: Photo) -> ImageCellModel {
    return ImageCellModel(id: photo.identifier, source: self)
  }
  
  fileprivate var _photoService = PhotoService()
  fileprivate var _models: [Photo] = []
  fileprivate var _modelsToDelete: [IndexPath: Photo] = [:]
  fileprivate var _currentModelIndex = 0
}

extension ImageSource: ImageCellModelDatasource {
  func image(for id: String, completion: @escaping (UIImage?) -> Void) {
    _photoService.requestImage(for: id, completion: completion)
  }
}

extension ImageSource: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
    let data = _models[indexPath.row]
    let m = _imageCellModel(from: data)
    m.selected = _modelsToDelete[indexPath] != nil
    cell.update(with: m)
  
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
    
    if _modelsToDelete[indexPath] == nil {
      _modelsToDelete[indexPath] = _models[indexPath.row]
    } else {
      _modelsToDelete.removeValue(forKey: indexPath)
    }
    
    let m = _imageCellModel(from: _models[indexPath.row])
    m.selected = _modelsToDelete[indexPath] != nil
    cell.update(with: m)
    
    output?.canRemove(_modelsToDelete.count > 0)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    output?.interaction(started: true)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let cellWidth = scrollView.contentSize.width / CGFloat(_models.count)
    let offset = scrollView.contentOffset.x
    
    let number = (offset + cellWidth / 2) / cellWidth
    
    _currentModelIndex = Int(number)
    
    output?.interaction(started: false)
  }
}

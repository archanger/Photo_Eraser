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
}

class ImageSource: NSObject {

  weak var output: ImageSourceOutupt?
  
  override init() {
    super.init()
    
    _photoService.requestAuth(completion: onRequestCompletion(status:))
  }
  
  private func onRequestCompletion(status: Bool) {
    guard status == true else {
      print("Сам дурак")
      return
    }
    
    _photoService.fetchPhotos { (result) in
      
      self.prepareData(assets: result);
    }
  }
  
  private func prepareData(assets: [Photo]) {
    for asset in assets {
      let model = ImageCellModel(id: asset.identifier, source: self)
      _models.append(model)
    }
    output?.reload()
  }
  
  fileprivate var _photoService = PhotoAssetService()
  fileprivate var _imageManager = PHCachingImageManager()
  fileprivate var _models: [ImageCellModel] = []
}

extension ImageSource: ImageCellModelDatasource {
  func image(for id: String, completion: @escaping (UIImage?) -> Void) {
    _photoService.fetchAsset(by: id) { (result) in
      if let asset = result.firstObject, asset.mediaType == .image {
        self._imageManager.requestImage(
          for: asset,
          targetSize: CGSize(width: 100, height: 100),
          contentMode: PHImageContentMode.aspectFill,
          options: nil,
          resultHandler: { (image, info) in
            completion(image)
        })
      } else {
        completion(nil)
      }
    }
  }
}

extension ImageSource: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
    let data = _models[indexPath.row]
  
    cell.update(with: data)
  
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _models.count
  }
}

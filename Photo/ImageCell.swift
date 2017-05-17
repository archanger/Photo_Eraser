//
//  ImageCell.swift
//  Photo
//
//  Created by Kirill on 16.05.17.
//  Copyright © 2017 Appreal LLC. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    _imageView.image = nil
    
  }
  
  func update(with model: ImageCellModel) {
    let id = model.identifier
    model.reauestImage { (image) in
      self._imageView.image = image
    }
  }
  
  @IBOutlet fileprivate weak var _imageView: UIImageView!
}

protocol ImageCellModelDatasource {
  func image(for id: String, completion: @escaping (UIImage?) -> Void)
}

class ImageCellModel {
  var identifier: String
  
  func reauestImage(completion: @escaping (UIImage?) -> Void) {
    self.delegate.image(for: self.identifier, completion: completion)
  }
  
  init(id: String, source: ImageCellModelDatasource) {
    self.identifier = id
    self.delegate = source
  }
  
  private var delegate: ImageCellModelDatasource
}

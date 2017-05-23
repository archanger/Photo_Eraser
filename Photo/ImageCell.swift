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
  
  private func setChosen(yesNo: Bool) {
    layer.borderWidth = yesNo ? 2 : 0
    layer.borderColor = UIColor.red.cgColor
  }
  
  func update(with model: ImageCellModel) {
    //let id = model.identifier
    model.reauestImage { (image) in
      DispatchQueue.main.async {
        self._imageView.image = image
      }
    }
    setChosen(yesNo: model.selected)
    
  }
  
  @IBOutlet fileprivate weak var _imageView: UIImageView!
}

protocol ImageCellModelDatasource {
  func image(for id: String, completion: @escaping (UIImage?) -> Void)
}

class ImageCellModel {
  var identifier: String
  var selected: Bool = false
  
  func reauestImage(completion: @escaping (UIImage?) -> Void) {
    self.delegate.image(for: self.identifier, completion: completion)
  }
  
  init(id: String, source: ImageCellModelDatasource) {
    self.identifier = id
    self.delegate = source
  }
  
  private var delegate: ImageCellModelDatasource
}

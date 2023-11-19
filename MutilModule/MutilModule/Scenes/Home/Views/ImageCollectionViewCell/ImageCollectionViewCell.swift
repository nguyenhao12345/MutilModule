//
//  ImageCollectionViewCell.swift
//  MutilModule
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit
import Commons

final class ImageCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet private(set) weak var thumbnail: UIImageView!
    
    func setImage(_ image: UIImage?) {
        thumbnail.image = image
    }
}

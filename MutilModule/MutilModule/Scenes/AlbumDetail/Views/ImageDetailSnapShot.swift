//
//  ImageDetailSnapShot.swift
//  MutilModule
//
//  Created by NguyenHao on 11/11/2023.
//

import UIKit

public class ImageDetailSnapShot: UIView {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public init(image: UIImage, frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupView(image: image, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit ImageDetailSnapShot")
    }
    
    private func setupView(image: UIImage, frame: CGRect) {
        imageView = UIImageView(frame: frame)
        imageView.image = image
        addSubview(imageView)
    }
    
    public func move(pointX x: CGFloat, pointY y: CGFloat) {
        self.imageView.transform = self.imageView.transform.translatedBy(x: x, y: y)
    }
}

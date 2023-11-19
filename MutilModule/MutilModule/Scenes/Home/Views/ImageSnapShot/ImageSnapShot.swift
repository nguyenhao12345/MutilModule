//
//  ImageSnapShot.swift
//  MutilModule
//
//  Created by NguyenHao on 18/11/2023.
//

import UIKit
import Commons

public class ImageSnapShot: UIView, ZoomAble {
    private var imageView: UIImageView = {
        return UIImageView()
    }()
    
    private var image: UIImage
    private let frameCell: CGRect
    private let targetWidth: CGFloat
    
    init(image: UIImage, frameCell: CGRect, targetWidth: CGFloat) {
        self.image = image
        self.frameCell = frameCell
        self.targetWidth = targetWidth
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        imageView = UIImageView(frame: frameCell)
        imageView.image = image
        addSubview(imageView)
    }
    
    public func actionZoom(duration: TimeInterval, animation: @escaping VoidCallBack, completion: ((Bool) -> Void)?) {
        let scaleX = frame.width / frameCell.width
        let newHeight = image.heightOfImage(with: targetWidth)
        let scaleY = newHeight / frameCell.height
        
        let centerXOfScreen = center.x
        let centerYOfScreen = center.y
        
        let pointX = centerXOfScreen - (frameCell.minX + frameCell.width / 2)
        let pointY = centerYOfScreen - (frameCell.minY + frameCell.height / 2)
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = .black
            self.imageView.transform = self.imageView.transform.translatedBy(x: pointX, y: pointY).scaledBy(x: scaleX, y: scaleY)
            animation()
        }, completion: completion)
    }
}

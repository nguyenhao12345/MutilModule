//
//  BaseButton.swift
//  Commons
//
//  Created by NguyenHao on 28/10/2023.
//

import UIKit

open class BaseButton: UIButton {
    public var touchUpInsideCallback: VoidCallBack?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(self.touchUpInsideButton), for: .touchUpInside)
    }
    
    @objc private func touchUpInsideButton() {
        touchUpInsideCallback?()
    }
}

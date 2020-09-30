//
//  CustomContainerView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class CustomContainerView: UIView {
    
    init(image: UIImage, textField: UITextField? = nil) {
        super.init(frame: .zero)
        
//        backgroundColor  = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 5
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.7
        addSubview(iv)
        
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 24, width: 24)
        
        guard let textField = textField else { return }
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: iv.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingBottom: 2)
        
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

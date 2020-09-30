//
//  CustomTextField.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String, isSecureField: Bool? = false) {
        super.init(frame: .zero)
        
//        let spacer = UIView()
//        spacer.setDimensions(height: 50, width: 12)
//        leftView = spacer
//        leftViewMode = .always
        
        
        
        keyboardAppearance = .dark
        borderStyle = .none
        textColor = .white
        isSecureTextEntry = isSecureField!
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]) //Faded Placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  HomeNavigationStackView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 17/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

protocol HomeNavigationStackViewDelegate: class {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    
    // MARK: - Properties
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(handleShowMessages), for: .touchUpInside)
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleShowSettings(){
        delegate?.showSettings()
    }
    
    @objc func handleShowMessages(){
        delegate?.showMessages()
    }
    
}

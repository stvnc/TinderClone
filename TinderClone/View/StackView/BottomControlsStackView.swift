//
//  BottomControlsStackView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 18/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

protocol  BottomControlsStackViewDelegate: class {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class BottomControlsStackView: UIStackView {
    
    
    // MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superLikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .fillEqually
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    
    @objc func handleRefresh(){
        delegate?.handleRefresh()
    }
    
    @objc func handleDislike(){
        delegate?.handleDislike()
    }
    
    @objc func handleLike(){
        delegate?.handleLike()
    }
}

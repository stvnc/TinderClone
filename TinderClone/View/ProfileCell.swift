//
//  ProfileCell.swift
//  TinderClone
//
//  Created by Vincent Angelo on 22/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit


class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

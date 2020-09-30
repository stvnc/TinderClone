//
//  SegmentedBarView.swift
//  TinderClone
//
//  Created by Vincent Angelo on 22/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(withCount count: Int){
        super.init(frame: .zero)
        
        (0..<count).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            addArrangedSubview(barView)
        }
        
        spacing = 4
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .white
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach ({  $0.backgroundColor = .barDeselectedColor})
        arrangedSubviews[index].backgroundColor = .white
    }
    
}

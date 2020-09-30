//
//  ChatController.swift
//  TinderClone
//
//  Created by Vincent Angelo on 24/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class ChatController: UICollectionViewController {
    private let user: User
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

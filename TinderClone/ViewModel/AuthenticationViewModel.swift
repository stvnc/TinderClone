//
//  AuthenticationViewModel.swift
//  TinderClone
//
//  Created by Vincent Angelo on 19/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
}

struct RegistrationViewModel {
    var email: String?
    var fullname: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && fullname?.isEmpty == false && password?.isEmpty == false
    }
    
}

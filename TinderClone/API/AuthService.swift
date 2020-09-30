//
//  AuthService.swift
//  TinderClone
//
//  Created by Vincent Angelo on 19/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    
    
    func registerUser(credentials: AuthCredentials, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("Failed to create user with error \(error.localizedDescription)")
            }
            
            ref.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageURLs": [profileImageURL],
                                "uid": uid] as [String:Any]
                    
                    COLLECTION_USERS.document(uid).setData(data, completion: completion)
                }
            }
        }
    }
    
    static func logUserOut(){
        do{
            try Auth.auth().signOut()
        } catch let error{
            print("DEBUG: Failed to sign user out, \(error.localizedDescription)")
        }
    }
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}

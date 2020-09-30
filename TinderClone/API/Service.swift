//
//  Service.swift
//  TinderClone
//
//  Created by Vincent Angelo on 19/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation
import Firebase

struct Service {
    
    static let shared = Service()
    
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("DEBUG: ERROR is \(error.localizedDescription)")
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullname": user.name,
                    "profileImageURLs": user.profileImageURLs,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge
        ] as [String:Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let shouldLike = isLike ? 1 : 0
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            let data = [user.uid: isLike]
            
            snapshot?.exists == true ? COLLECTION_SWIPES.document(uid).updateData(data, completion: completion) :
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
        }
        
    }
    
    static func fetchSwipes(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String:Bool]())
                return
            }
            
            completion(data)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        let minAge = user.minSeekingAge
        let maxAge = user.maxSeekingAge
        
        let query = COLLECTION_USERS.whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        
        Service.fetchSwipes { swipedUserIDs in
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return }
                    users.append(user)
                    // jadi hanya mereturn sejumlah user dalam db, kalau tidak akan menciptakan duplicate
//                    if users.count == snapshot.documents.count - 1 {
//                        completion(users)
//                    }
                })
                completion(users)
            }
        }
        
        
    }
    
    static func fetchMatches(completion: @escaping([Matches]) -> Void ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { (snapshot, error) in
            guard let data = snapshot else { return }
            
            let matches = data.documents.map ({ Matches(dictionary: $0.data() )})
            
            completion(matches)
            
            // longway
            
//            let var matches = [Matches]()
//            data.documents.forEach { document in
//                let match = Matches(dictionary: document.data())
//                matches.append(match)
//            }
//            completion(matches)
            
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(user.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[uid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageURL = matchedUser.profileImageURLs.first else { return }
        guard let currentUserProfileImageURL = currentUser.profileImageURLs.first else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                    "name": matchedUser.name,
                    "profileImageURL": profileImageURL]
        
        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches").document(matchedUser.uid).setData(matchedUserData)
        
        let currentUserData = ["uid": currentUser.uid,
                    "name": currentUser.name,
                    "profileImageURL": currentUserProfileImageURL]
        
        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
    }
    
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Error uploading image \(error.localizedDescription)")
            }
            
            ref.downloadURL { (url, error) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}

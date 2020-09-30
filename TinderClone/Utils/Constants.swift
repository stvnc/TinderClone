//
//  Constants.swift
//  TinderClone
//
//  Created by Vincent Angelo on 19/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Firebase

let STORAGE_REF = Storage.storage().reference(withPath: "/images/")

let COLLECTION_REF = Firestore.firestore()
let COLLECTION_USERS = COLLECTION_REF.collection("users")
let COLLECTION_SWIPES = COLLECTION_REF.collection("swipes")
let COLLECTION_MESSAGES = COLLECTION_REF.collection("messages")
let COLLECTION_MATCHES_MESSAGES = COLLECTION_REF.collection("matches_messages")

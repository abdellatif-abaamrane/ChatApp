//
//  Constant.swift
//  Uber
//
//  Created by macbook-pro on 21/05/2020.
//

import Foundation
import Firebase


let DB_RF = Firestore.firestore()
let REF_USERS = DB_RF.collection("users")
let REF_MESSAGES = DB_RF.collection("messages")
let REF_USERMESSAGES = DB_RF.collection("user_messages")

let AUTH = Auth.auth()
let STORAGE_RF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_RF.child(AUTH.currentUser!.uid).child("profile_images")

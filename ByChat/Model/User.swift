//
//  User.swift
//  Uber
//
//  Created by macbook-pro on 21/05/2020.
//

import Foundation
import Firebase



struct User {
    var uid : String
    var fullname : String
    var username : String
    var email : String
    var bio : String
    var timestamp : Date
    var profileImageURL : String
    var isCurrentUser : Bool {
        AUTH.currentUser?.uid == uid
    }
    init(uid:String,dictionary:[String:Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        let timestamp = dictionary["timestamp"] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
    }
}

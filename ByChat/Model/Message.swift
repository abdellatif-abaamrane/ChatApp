//
//  Message.swift
//  ByChat
//
//  Created by macbook-pro on 25/05/2020.
//

import Firebase


enum MessageKind {
    case audio
    case image
    case link
    case video
    case file
    case location
    case attributedText
}

class Message {
    var messageID: String
    var sender: User
    var receiver: User
    var body: String
    
    var timestamp : Date
    
    var isMine: Bool {
        sender.uid == AUTH.currentUser?.uid
    }
    var converser: User {
        isMine ? receiver : sender
    }
    
    init(messageID:String, sender:User, receiver:User, dictionary: [String:Any]) {
        self.messageID = messageID
        self.sender = sender
        self.receiver = receiver
        self.body = dictionary["body"] as? String ?? ""
        let timestamp = dictionary["timestamp"] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
    }
    
}


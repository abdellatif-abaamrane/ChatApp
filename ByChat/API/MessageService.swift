//
//  MessageService.swift
//  ByChat
//
//  Created by macbook-pro on 26/05/2020.
//

import Firebase



class MessageService {
    static let shared = MessageService()
    
    func sendMessage(caption:String, to userID:String, completionHandler: @escaping (Error?)->Void ) {
        guard let uid = AUTH.currentUser?.uid else { return }
        let data : [String:Any] = ["body" : caption,
                                   "timestamp": Date(),
                                   "sender": uid,
                                   "receiver": userID]
        let Ref = REF_MESSAGES.document(uid).collection(userID).document()
        Ref.setData(data) { error in
            if let error = error {
                completionHandler(error)
                return
            }
            
            REF_MESSAGES.document(userID).collection(uid).document(Ref.documentID).setData(data) { error in
                if let error = error {
                    completionHandler(error)
                    return
                }
                let date = Date()
                REF_USERMESSAGES.document(uid).collection("messages").document(userID).setData(["messageID" : Ref.documentID,"timestamp":date],merge: true) { error in
                    if let error = error {
                        completionHandler(error)
                        return
                    }
                    REF_USERMESSAGES.document(userID).collection("messages").document(uid).setData(["messageID" : Ref.documentID,"timestamp":date],merge: true,completion: completionHandler)
                }
            }
        }
    }

    func fetchMessage(messageID:String,userID:String,completionHandler:@escaping(Result<Message,Error>)->Void) {
        guard let uid = AUTH.currentUser?.uid else { return }
        
        REF_MESSAGES.document(uid).collection(userID).document(messageID).getDocument { message, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let message = message,
                  let data = message.data() else { return }
            if let senderID = data["sender"] as? String {
                print(senderID)
                UserService.shared.fetchUser(uid: senderID) { senderResult in
                    switch senderResult {
                    case .success(let sender):
                        if let receiverID = data["receiver"] as? String {
                            UserService.shared.fetchUser(uid: receiverID) { receiverResult in
                                switch receiverResult {
                                case .success(let receiver):
                                    let message = Message(messageID: message.documentID,
                                                          sender: sender,
                                                          receiver: receiver,
                                                          dictionary: data)
                                    completionHandler(.success(message))
                                case .failure(let error):
                                    completionHandler(.failure(error))
                                }
                            }
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    var messages1 = [Message]()
     func getUserConversers(_ completionHandler: @escaping (Result<[Message],Error>)->Void ) {
        guard let uid = AUTH.currentUser?.uid else { return }
        REF_USERMESSAGES.document(uid).collection("messages").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { messageSnapshot in
                let userID = messageSnapshot.documentID
                guard let messageID = messageSnapshot.data()["messageID"] as? String else { return }
                self.fetchMessage(messageID: messageID, userID: userID) { result in
                    switch result {
                    case .success(let message):
                        self.messages1.append(message)
                        if self.messages1.count == snapshot.count {
                            self.messages1.sort { $0.timestamp > $1.timestamp }
                            completionHandler(.success(self.messages1))
                            self.messages1 = []
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    enum ChangeType {
        case added(messages: [Message])
        case modified(message: Message)
    }
    var addedMessages = [Message]()

    func listenToUserConversers(_ completionHandler: @escaping (Result<ChangeType,Error>)->Void ) {
        guard let uid = AUTH.currentUser?.uid else { return }
        REF_USERMESSAGES.document(uid).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            let addedConverser = snapshot.documentChanges.filter { $0.type == .added }.map { $0.document }
            addedConverser.forEach { messageSnapshot in
                let userID = messageSnapshot.documentID
                guard let messageID = messageSnapshot.data()["messageID"] as? String else { return }
                self.fetchMessage(messageID: messageID, userID: userID) { result in
                    switch result {
                    case .success(let message):
                        self.addedMessages.append(message)
                        if self.addedMessages.count == addedConverser.count {
                            self.addedMessages.sort { $0.timestamp < $1.timestamp }
                            completionHandler(.success(.added(messages: self.addedMessages)))
                            self.addedMessages = []
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
            snapshot.documentChanges.filter { $0.type == .modified }.map { $0.document }.forEach { messageSnapshot in
                let userID = messageSnapshot.documentID
                guard let messageID = messageSnapshot.data()["messageID"] as? String else { return }
                self.fetchMessage(messageID: messageID, userID: userID) { result in
                    switch result {
                    case .success(let message):
                        print(message.body)
                        completionHandler(.success(.modified(message: message)))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            }
        }
    }
    
    
    
    func listenConversetion(with user:User,_ completionHandler: @escaping (Result<Message,Error>)->Void ) {
        guard let uid = AUTH.currentUser?.uid else { return }
        REF_MESSAGES.document(uid).collection(user.uid).whereField("timestamp", isGreaterThanOrEqualTo: Date()).order(by: "timestamp", descending: false).addSnapshotListener { snapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documentChanges.filter { $0.type == .added }.map({ $0.document }).forEach { message in
                if let senderID = message.data()["sender"] as? String {
                    UserService.shared.fetchUser(uid: senderID) { result in
                        switch result {
                        case .success(let sender):
                            if let receiverID = message.data()["receiver"] as? String {
                                UserService.shared.fetchUser(uid: receiverID) { user in
                                    switch result {
                                    case .success(let receiver):
                                        let message = Message(messageID: message.documentID,
                                                              sender: sender,
                                                              receiver: receiver,
                                                              dictionary: message.data())
                                        completionHandler(.success(message))
                                    case .failure(let error):
                                        completionHandler(.failure(error))
                                    }
                                }
                            }
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                }
            }
        }
    }
    var messages2 = [Message]()
    func getConversetion(with user:User,_ completionHandler: @escaping (Result<[Message],Error>)->Void ) {
        guard let uid = AUTH.currentUser?.uid else { return }
        REF_MESSAGES.document(uid).collection(user.uid).order(by: "timestamp", descending: true).limit(to: 10).getDocuments(completion: { snapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { message in
                if let senderID = message.data()["sender"] as? String {
                    UserService.shared.fetchUser(uid: senderID) { result in
                        switch result {
                        case .success(let sender):
                            if let receiverID = message.data()["receiver"] as? String {
                                UserService.shared.fetchUser(uid: receiverID) { user in
                                    switch result {
                                    case .success(let receiver):
                                        let message = Message(messageID: message.documentID,
                                                              sender: sender,
                                                              receiver: receiver,
                                                              dictionary: message.data())
                                        self.messages2.append(message)
                                        if self.messages2.count == min(10,snapshot.count) {
                                            self.messages2.sort { $0.timestamp < $1.timestamp }
                                            completionHandler(.success(self.messages2))
                                            self.messages2 = []
                                        }
                                    case .failure(let error):
                                        completionHandler(.failure(error))
                                    }
                                }
                            }
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                }
            }
        })
    }
    func listen() {
        
    }
}

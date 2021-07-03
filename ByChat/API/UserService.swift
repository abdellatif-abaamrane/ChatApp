//
//  UserService.swift
//  Uber
//
//  Created by macbook-pro on 21/05/2020.
//

import Foundation
import Firebase



struct UserService {
    static let shared = UserService()
    
    func updateUserData(user:User, _ completion: @escaping (Error?) -> Void) {
        let data = ["username":user.username,
                    "fullName":user.fullname,
                    "bio":user.bio,
                    "profileImageURL":user.profileImageURL]
        REF_USERS.document(user.uid).setData(data, merge: true, completion: completion)
    }
    
    
    func fetchCurrentUser(_ completionHandler: @escaping (Result<User, Error>) -> Void) {
        guard let uid = AUTH.currentUser?.uid else { return }
        REF_USERS.document(uid).addSnapshotListener { userSnapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let userSnapshot = userSnapshot,
               let data =  userSnapshot.data() {
                let user = User(uid: userSnapshot.documentID, dictionary: data)
                completionHandler(.success(user))
            }
        }
    }
    func fetchUser(uid: String,_ completionHandler: @escaping (Result<User, Error>) -> Void) {
        REF_USERS.document(uid).getDocument(source: .default) { userSnapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let userSnapshot = userSnapshot,
               let data =  userSnapshot.data() {
                let user = User(uid: userSnapshot.documentID, dictionary: data)
                completionHandler(.success(user))
            }
        }
    }
    
    func fetchUsers(_ completionHandler: @escaping (Result<[User], Error>) -> Void) {
        guard let uid = AUTH.currentUser?.uid else { return }
        let source = FirestoreSource.default
        REF_USERS.getDocuments(source: source) { snapshot, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let snapshot = snapshot {
                let users = snapshot.documents.map({ user in
                    User(uid: user.documentID, dictionary: user.data())
                })
                completionHandler(.success(users))
            }
        }
    }
    
}

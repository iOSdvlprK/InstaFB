//
//  FirebaseUtils.swift
//  InstaFB
//
//  Created by joe on 2023/02/10.
//

import Foundation

struct FBExtension {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        dbRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot, _ in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
            
        } withCancel: { err in
            print("Failed to fetch user for posts:", err)
        }
    }
}


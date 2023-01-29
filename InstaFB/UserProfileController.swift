//
//  UserProfileController.swift
//  InstaFB
//
//  Created by joe on 2023/01/28.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UICollectionViewController {
    
    var dbRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        navigationItem.title = Auth.auth().currentUser?.uid
        dbRef = Database.database(url: "https://instafb-58b4d-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        dbRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
        } withCancel: { err in
            print("Failed to fetch user:", err)
        }

    }
}

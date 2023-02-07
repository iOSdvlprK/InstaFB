//
//  HomeController.swift
//  InstaFB
//
//  Created by joe on 2023/02/06.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var dbRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        dbRef = Database.database(url: "https://instafb-58b4d-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        setupNavigationItems()
        fetchPosts()
    }
    
    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = dbRef.child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value) { snapshot, _  in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                print("Key: \(key), Value: \(value)")
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            }
            
            self.collectionView.reloadData()
            
        } withCancel: { err in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

//
//  CommentsController.swift
//  InstaFB
//
//  Created by joe on 2023/02/21.
//

import UIKit
import FirebaseAuth

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var post: Post?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .systemRed
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    var comments = [Comment]()
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        dbRef.child("comments").child(postId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let comment = Comment(dictionary: dictionary)
//            print(comment.text, comment.uid)
            self.comments.append(comment)
            self.collectionView.reloadData()
            
        } withCancel: { err in
            print("Failed to observe comments")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 82)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.label, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(nil, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
//        let textField = UITextField()
//        textField.placeholder = "Enter Comment"
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: submitButton.leadingAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    @objc fileprivate func handleSubmit() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        print("post id:", self.post?.id ?? "")
        print("Inserting comment:", commentTextField.text ?? "")
        
        let postId = self.post?.id ?? ""
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        
        dbRef.child("comments").child(postId).childByAutoId().updateChildValues(values) { err, ref in
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            print("Successfully inserted comment.")
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

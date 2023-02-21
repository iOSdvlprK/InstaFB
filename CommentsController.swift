//
//  CommentsController.swift
//  InstaFB
//
//  Created by joe on 2023/02/21.
//

import UIKit

class CommentsController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .systemRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    var containerView: UIView = {
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
        
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        containerView.addSubview(textField)
        textField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: submitButton.leadingAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    @objc fileprivate func handleSubmit() {
        print("Handling Submit..")
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

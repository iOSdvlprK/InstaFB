//
//  ViewController.swift
//  InstaFB
//
//  Created by joe on 2023/01/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dbRef: DatabaseReference!
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(nil, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true)
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        tf.backgroundColor = UIColor.systemGray6
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(nil, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        tf.backgroundColor = UIColor.systemGray6
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(nil, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .label
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
//        tf.isSecureTextEntry = true  // this causes error when connecting auth server
        tf.backgroundColor = UIColor.systemGray6
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(nil, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Failed to create user:", error!.localizedDescription)
                return
            }
            print("Successfully created user:", user.uid)
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let storageRef = Storage.storage().reference()
            let filename = UUID().uuidString
            
            self.uploadImage(storageRef: storageRef, filename: filename, imgData: uploadData) { imageUrl in
                let uid = user.uid
                let dictionaryValues = ["username": username, "profileImageUrl": imageUrl]
                let values = [uid: dictionaryValues]

    //            self.dbRef.child("users").setValue(values) { err, dbRef in
                self.dbRef.child("users").updateChildValues(values) { err, dbRef in
                    if let err = err {
                        print("Failed to save user info to db:", err)
                        return
                    }
                    print("Successfully saved user info to db")
                    
                    guard let mainTabBarController = self.view.window?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    fileprivate func uploadImage(storageRef: StorageReference, filename: String, imgData: Data, completion: @escaping (String) -> Void) {
        storageRef.child("profile_images").child(filename).putData(imgData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
//                guard let metadata = metadata else { return }
//                let size = metadata.size
            
            storageRef.child("profile_images").child(filename).downloadURL { url, err in
                guard let downloadURL = url else { return }
                print("Successfully uploaded profile image:", downloadURL.absoluteString)
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.systemGray])
        attributedTitle.append(NSAttributedString(string: "Sign In.", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(nil, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        
        setupInputFields()
        
        dbRef = Database.database(url: "https://instafb-58b4d-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    }

    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


//
//  CommentInputAccessoryView.swift
//  InstaFB
//
//  Created by joe on 2023/03/01.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextField.text = nil
    }
    
    fileprivate let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.label, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(nil, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .systemRed
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        addSubview(commentTextField)
        commentTextField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: submitButton.leadingAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = .systemGray5
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    @objc fileprivate func handleSubmit() {
        guard let commentText = commentTextField.text else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

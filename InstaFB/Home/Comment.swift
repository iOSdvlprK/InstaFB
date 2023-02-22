//
//  Comment.swift
//  InstaFB
//
//  Created by joe on 2023/02/22.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

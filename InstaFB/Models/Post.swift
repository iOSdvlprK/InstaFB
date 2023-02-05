//
//  Post.swift
//  InstaFB
//
//  Created by joe on 2023/02/05.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}

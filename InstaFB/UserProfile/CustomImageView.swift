//
//  CustomImageView.swift
//  InstaFB
//
//  Created by joe on 2023/02/05.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        print("Loading image...")
        
        lastURLUsedToLoadImage = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            // to prevent the cell from loading the same image again
            // (implemented based on the asynchronism of URLSession)
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}

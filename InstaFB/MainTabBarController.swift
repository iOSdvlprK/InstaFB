//
//  MainTabBarController.swift
//  InstaFB
//
//  Created by joe on 2023/01/28.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}

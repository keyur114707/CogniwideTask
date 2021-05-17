//
//  TabBarMenuViewController.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 16/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import UIKit

class TabBarMenuViewController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = "Post"
        tabBar.items?[1].title = "Favourite"
        tabBarController?.selectedIndex = 0
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "#909090") ?? UIColor.lightGray, NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 16) as Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "#FF0000") ?? UIColor.systemRed,NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 16) as Any], for: .selected)
    }
}

//
//  UIViewController-Extension.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 16/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import UIKit

extension UIViewController {
  
  /// Add Menu
  func addMenu() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainViewController  = storyboard.instantiateViewController(withIdentifier:"TabBarMenuViewController")
    UIApplication.shared.keyWindow?.rootViewController = mainViewController
    UIApplication.shared.keyWindow?.makeKeyAndVisible()
  }
  
}

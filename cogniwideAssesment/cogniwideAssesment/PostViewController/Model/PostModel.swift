//
//  PostModel.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation

class PostElement: Codable {
    let body: String
    let id: Int64
    let title: String
    let userID: Int64
    var favourite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case body, id, title
        case userID = "userId"
    }
}

typealias Post = [PostElement]

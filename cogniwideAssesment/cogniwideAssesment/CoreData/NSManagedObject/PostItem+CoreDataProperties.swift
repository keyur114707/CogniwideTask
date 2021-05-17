//
//  PostItem+CoreDataProperties.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 15/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation
import CoreData


extension PostItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostItem> {
        return NSFetchRequest<PostItem>(entityName: "PostItem")
    }
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var favourite: Bool
}

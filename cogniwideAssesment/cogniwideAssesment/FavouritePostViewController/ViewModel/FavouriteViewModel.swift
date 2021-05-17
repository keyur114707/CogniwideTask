//
//  FavouriteViewModel.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 16/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation


class FavouriteViewModel {
    var favouritePostArray = [PostItem]()
    let coreDataManager = CoreDataManager.shared()
    
    /// Description: setting un favourite method
    /// - Parameter index: index is row number
    func setFavouritePostFromFavourite(at index:Int) {
        if index < favouritePostArray.count {
            let post = favouritePostArray[index]
                if post.favourite {
                    post.favourite = false
                    coreDataManager.updatePostItem(for:post.id, isFavourite:false)
                } else {
                    post.favourite = true
                    coreDataManager.updatePostItem(for:post.id, isFavourite:true)
                }
        }
    }
    
    
    /// Description :- array of post items for all favourite posts
    /// - Returns: [PostItem]
    func getFavouritePosts() ->  [PostItem]? {
        let favouriteArray = self.coreDataManager.fetchPostItems()
        favouritePostArray = favouriteArray.filter({$0.favourite == true})
        return favouritePostArray
    }
    
    
    /// Description:- returning the favourite status true or false
    /// - Parameter index: index is row number
    /// - Returns: Bool
    func getFavouritePostStatusFromFavourite(at index:Int) -> Bool? {
        if index < favouritePostArray.count {
            let post = favouritePostArray[index]
            return post.favourite
        }
        return nil
    }
    
    /// Description : - return PostItem based on index
    /// - Parameter index:  index is row number
    /// - Returns: PostItem
    func getFavouritePost(at index:Int) -> PostItem? {
        if index < favouritePostArray.count {
            return favouritePostArray[index]
        }
        return nil
    }
}

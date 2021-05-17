//
//  PostViewModel.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation
import RxSwift

class PostViewModel: NSObject {
    let rx_tableview_reload = PublishSubject<Bool>()
    
    var postArray = [PostItem]()
    var disposebag = DisposeBag()
    let coreDataManager = CoreDataManager.shared()
    var filterArray = [PostItem]()
    
    /// Description: getting all posts
    func getAllPosts() {
        let postApi = PostAPI()
        if !postApi.rx_postResponse.hasObservers {
            postApi.rx_postResponse.subscribe(onNext: { (post) in
                if post.count != self.postArray.count {
                    self.coreDataManager.prepare(post)
                    self.postArray = self.coreDataManager.fetchPostItems()
                }
                self.rx_tableview_reload.onNext(true)
            }, onError: { (error) in
                
            }).disposed(by: disposebag)
        }
        postApi.getPostList()
    }
    
    /// Description : - return PostItem based on index
    /// - Parameter index:  index is row number
    /// - Returns: PostItem
    func getPost(at index:Int) -> PostItem? {
        return postArray[index]
    }
    
    //// Description : - return PostItem based on index for filter array
    /// - Parameter index:  index is row number
    /// - Returns: PostItem
    func getFileredPost(at index:Int) -> PostItem? {
        return filterArray[index]
    }

    /// Description :- returning the favourite status true or false
    /// - Parameters:
    ///   - index: index is row number
    ///   - isFiltered: check flag for filtered/non filtered status
    /// - Returns: Bool
    func getFavouritePostStatus(at index:Int,isFiltered:Bool) -> Bool? {
        if isFiltered {
            if index < filterArray.count {
                let post = filterArray[index]
                return post.favourite
            }
        } else {
            if index < postArray.count {
                let post = postArray[index]
                return post.favourite
            }
        }
        
        return nil
    }
    
    
    /// Description:- setting post as favourite/non favourite
    /// - Parameters:
    ///   - index: index is row number
    ///   - isFiltered: check flag for filtered/non filtered status
    func setFavouritePost(at index:Int,isFiltered:Bool) {
        if isFiltered {
            if index < filterArray.count {
                let post = filterArray[index]
                    if post.favourite {
                        post.favourite = false
                        coreDataManager.updatePostItem(for:post.id, isFavourite:false)
                    } else {
                        post.favourite = true
                        coreDataManager.updatePostItem(for:post.id, isFavourite:true)
                    }
            }
        } else {
            if index < postArray.count {
                let post = postArray[index]
                    if post.favourite {
                        post.favourite = false
                        coreDataManager.updatePostItem(for:post.id, isFavourite:false)
                    } else {
                        post.favourite = true
                        coreDataManager.updatePostItem(for:post.id, isFavourite:true)
                    }
            }
        }
    }
}

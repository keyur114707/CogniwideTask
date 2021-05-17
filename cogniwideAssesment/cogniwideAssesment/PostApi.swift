//
//  PostApi.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift

class APIResponse {
    var data: [[String:Any]] = [[:]]
    init(dataResponse:[[String:Any]]) {
        data = dataResponse
    }
}

class PostAPI: NSObject {
    let disposebag = DisposeBag()
    let rx_postResponse = PublishSubject<Post>()
    var postsArray = Post()
    func getPostList(){
        
        let strURL = "https://jsonplaceholder.typicode.com/posts"
        RxAlamofire
            .requestJSON(.get, strURL,headers: nil)
            .subscribe(onNext: { (r,json) in
                if  let dict  = json as? [[String:Any]] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        let reqJSONStr = String(data: jsonData, encoding: .utf8)
                        let data = reqJSONStr?.data(using: .utf8)
                        let jsonDecoder = JSONDecoder()
                        let post = try jsonDecoder.decode(Post.self, from: data!)
                        self.postsArray = post
                        self.rx_postResponse.onNext(self.postsArray)
                        print(post)
                    }
                    catch {
                    }
//                    let response : APIResponse?
//                    response = APIResponse.init(dataResponse: dict)
//                    self.rx_postResponse.onNext(response ?? APIResponse(dataResponse: [[ : ]]))
                }
            }, onError: {  (error) in
                  self.rx_postResponse.onError(error)
            }).disposed(by: disposebag)
    }
}

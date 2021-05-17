//
//  FavouriteViewController.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 15/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import UIKit
import RxSwift

class FavouriteViewController: UIViewController {
    @IBOutlet weak var favouritePostTableview: UITableView!
    var viewModel = FavouriteViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Favourite"
        favouritePostTableview.reloadData()
    }
    
    /// Description : favourite button action to make it non favourite
    /// - Parameter sender: UIButton
    @objc func favouriteButtonAction(sender : UIButton){
        let index = (sender as UIButton).tag
        viewModel.setFavouritePostFromFavourite(at: index)
        favouritePostTableview.reloadData()
    }
}


extension FavouriteViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getFavouritePosts()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let post = viewModel.getFavouritePost(at:indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:PostTableViewCell.self), for: indexPath) as? PostTableViewCell {
            cell.favouriteButton.tag = indexPath.row
            if let favourite = viewModel.getFavouritePostStatusFromFavourite(at:indexPath.row) {
                if favourite {
                    cell.favouriteButton.isSelected = true
                } else {
                    cell.favouriteButton.isSelected = false
                }
            }
            cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
            cell.updateCellData(title: post.title ?? "", description: post.body ?? "")
            return cell
        }
        return UITableViewCell()
    }
    
}

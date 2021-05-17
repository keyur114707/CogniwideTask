//
//  PostViewController.swift
//  cogniwideAssesment
//
//  Created by Keyur Patel on 14/05/21.
//  Copyright © 2021 cogniwide. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class PostViewController: UIViewController {
    @IBOutlet weak var postTableview: UITableView!
    @IBOutlet weak var searchBaroutlet: UISearchBar!
    
    var viewModel = PostViewModel()
    var disposeBag = DisposeBag()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Post"
        searchBaroutlet.returnKeyType = .done
        searchBaroutlet.enablesReturnKeyAutomatically = false
        setObserverForTableviewReload()
        viewModel.getAllPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeRxObserver()
    }
    
    /// Description: set observer method for reload tableview
    func setObserverForTableviewReload() {
        if !viewModel.rx_tableview_reload.hasObservers {
            viewModel.rx_tableview_reload.subscribe(onNext: { (success) in
                if success {
                    self.postTableview.reloadData()
                }
            }, onError: { error in
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
        }
    }
    
    
    /// Description: observer remove method
    func removeRxObserver() {
        viewModel.disposebag = DisposeBag()
        disposeBag = DisposeBag()
    }
    
    /// Description : favourite button action to make it favourite/non favourite
    /// - Parameter sender: UIButton
    @objc func favouriteButtonAction(sender : UIButton){
        let index = (sender as UIButton).tag
        viewModel.setFavouritePost(at: index,isFiltered: searching)
        postTableview.reloadData()
    }
    
    /// Description : - keyboard dismiss method
    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
}

extension PostViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return  viewModel.filterArray.count
        } else {
             return viewModel.postArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searching {
            if let post = viewModel.getFileredPost(at:indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:PostTableViewCell.self), for: indexPath) as? PostTableViewCell {
                cell.favouriteButton.tag = indexPath.row
                if let favourite = viewModel.getFavouritePostStatus(at:indexPath.row, isFiltered: searching) {
                    if favourite {
                        cell.favouriteButton.isSelected = true
                    } else {
                        cell.favouriteButton.isSelected = false
                    }
                } else {
                    cell.favouriteButton.isSelected = false
                }
                cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
                cell.updateCellData(title: post.title ?? "", description: post.body ?? "")
                return cell
            }
        } else {
            if let post = viewModel.getPost(at:indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:PostTableViewCell.self), for: indexPath) as? PostTableViewCell {
                cell.favouriteButton.tag = indexPath.row
                if let favourite = viewModel.getFavouritePostStatus(at:indexPath.row, isFiltered: searching) {
                    if favourite {
                        cell.favouriteButton.isSelected = true
                    } else {
                        cell.favouriteButton.isSelected = false
                    }
                } else {
                    cell.favouriteButton.isSelected = false
                }
                cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
                cell.updateCellData(title: post.title ?? "", description: post.body ?? "")
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension PostViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searching = true
            viewModel.filterArray = viewModel.postArray.filter({
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            })
        } else {
            searching = false
        }
        postTableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        postTableview.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


//
//  ViewController.swift
//  DocTalk
//
//  Created by Sumeet Jain on 24/05/18.
//  Copyright © 2018 Sumeet Jain. All rights reserved.
//

import UIKit

var usersArr:[Int : String] = [:]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{

    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userNameTableView: UITableView!
    
    var searchResult :[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchBar.delegate = self
        userNameTableView.delegate = self
        userNameTableView.dataSource = self
        getUserNames()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userNameTableView.dequeueReusableCell(withIdentifier: "userDisplayCell")
         cell?.textLabel?.text = usersArr[searchResult[indexPath.row]]
        cell?.detailTextLabel?.text = String(describing: searchResult[indexPath.row])
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText != ""
        {
            let searchResultDict = usersArr.filter { $1.lowercased().contains(searchText.lowercased()) }
            searchResult = searchResultDict.keys.sorted().reversed()
        }else{
            searchResult.removeAll()
        }
        userNameTableView.reloadData()
    }
    
    func getUserNames()
    {
        BaseWebService.sharedInstance.getUsers { (response, error) in
            if let _ = response{
                print("Success")
            }else {
                print(error!.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


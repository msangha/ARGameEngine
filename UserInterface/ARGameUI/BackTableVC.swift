//
//  BackTableVC.swift
//  ARGameUI
//
//  Created by Tzer Wong on 9/19/15.
//  Copyright © 2015 Tzer Wong. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController{
    var TableArray = [String]()
    
    override func viewDidLoad() {
        TableArray = [ "Profile" , "Settings" , "Log out" ]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
    
        cell.textLabel?.text = TableArray[indexPath.row]
        
        return cell
        
    }
    
        
}
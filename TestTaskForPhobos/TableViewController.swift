//
//  TableViewController.swift
//  TestTaskForPhobos
//
//  Created by Виталий on 14.05.16.
//  Copyright © 2016 kvakvit. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var feeds: [PhobosApi.Feed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIImageView(image:UIImage(named:"background"))
        backgroundView.alpha = 0.5
        
        self.tableView.backgroundView = backgroundView
        self.tableView.contentInset = UIEdgeInsetsMake(20,0,0,0);
        
        self.tableView.estimatedRowHeight = 280
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl!.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        refresh()
    }
    
    func refresh() {
       
        PhobosApi().fetchObjects { (feeds: [PhobosApi.Feed]) -> () in
            self.feeds = feeds
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feeds.count
    }
    
    
    
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.createFeed(feeds[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let view = cell.contentView
            view.layer.opacity = 0.1
            UIView.animateWithDuration(1.4) {
                view.layer.opacity = 1
            
        }
    }

    
    
}

//
//  TableViewController.swift
//  TestTaskForPhobos
//
//  Created by Виталий on 14.05.16.
//  Copyright © 2016 kvakvit. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var feeds: [NSManagedObject] = []
    var didAnimateCell:[NSIndexPath: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIImageView(image:UIImage(named:"background"))
        backgroundView.alpha = 0.5
        
        self.tableView.backgroundView = backgroundView
        
        self.tableView.estimatedRowHeight = 280
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl!.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        PhobosApi().fetchObjectsFromCache { (feeds: [NSManagedObject]) -> () in
            if !feeds.isEmpty {
                self.feeds = feeds
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            } else {
                self.refresh()
            }
        }

        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let topOffest = CGPointMake(0, -(self.tableView.contentInset.top+25))
        self.tableView.contentOffset = topOffest
        
    }
    
    func refresh() {
       
        PhobosApi().fetchObjectsFromServer { (feeds: [NSManagedObject], connectError: NSError?) -> () in
            if connectError == nil {
                self.title = "Ваши траты:"
                self.feeds += feeds
                self.tableView.reloadData()
            } else {
                self.title = "Ваши траты: (Ошибка загрузки)"
                
            }
            self.refreshControl!.endRefreshing()
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    
    
   override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.createFeed(feeds[feeds.count-1 - indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if didAnimateCell[indexPath] == nil || didAnimateCell[indexPath]! == false {
            
            didAnimateCell[indexPath] = true
            let view = cell.contentView
            view.layer.opacity = 0.1
            UIView.animateWithDuration(1.4) {
                view.layer.opacity = 1
            }
            
        }
    }

    
    
}

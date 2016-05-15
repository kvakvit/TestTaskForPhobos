//
//  TableViewCell.swift
//  TestTaskForPhobos
//
//  Created by Виталий on 14.05.16.
//  Copyright © 2016 kvakvit. All rights reserved.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var happened_at: UILabel!
    
    
    
    func createFeed(feed: NSManagedObject) {

        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        
        details.text = feed.valueForKey("details") as? String
        amount.text = feed.valueForKey("amount") as? String
        categoryName.text = feed.valueForKey("categoryName") as? String
        comment.text = feed.valueForKey("comment") as? String
        happened_at.text = feed.valueForKey("happened_at") as? String
        
    }
}

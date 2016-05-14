//
//  TableViewCell.swift
//  TestTaskForPhobos
//
//  Created by Виталий on 14.05.16.
//  Copyright © 2016 kvakvit. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var happened_at: UILabel!
    
    
    
    func createFeed(feed: PhobosApi.Feed) {

        mainView.layer.cornerRadius = 10;
        mainView.layer.masksToBounds = true;
        
        details.text = feed.details
        amount.text = String(feed.amount)
        categoryName.text = feed.categoryName
        comment.text = feed.comment
        happened_at.text = feed.happened_at
        
    }
}

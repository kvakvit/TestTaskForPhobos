//
//  PhobosApi.swift
//  TestTaskForPhobos
//
//  Created by Виталий on 14.05.16.
//  Copyright © 2016 kvakvit. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PhobosApi {
    
    let url = "http://mobile165.hr.phobos.work/list"
    
    struct Feed {
        
        let amount: String
        let details: String
        let comment: String
        let categoryName: String
        let happened_at: String
        
    }
    
    func fetchObjects(callback: ([Feed]) -> Void) {
        request(.GET, url).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.populateObjects(json, callback: callback)
            case .Failure(let error):
                self.generateError(error, callback: callback)
            }
        }
        
    }
    
    func populateObjects(json: JSON, callback: ([Feed]) -> Void) {
        
        var objects = [Feed]()
            
        for var i = 3; i <= 5; i += 1 {
        
            for feed in json["feed"]["2014-04-1\(i)"].arrayValue {
            
                objects.append(Feed(amount: feed["money"]["amount"].stringValue + " RUB", details: feed["details"].stringValue, comment: feed["comment"].stringValue, categoryName: "Категория: " + feed["category"]["name"].stringValue, happened_at: dateStringFromUnixTime(feed["happened_at"].intValue)))
        
            }
        
        }
        
        callback(objects)
        
    }
    
    func generateError(error: NSError, callback: ([Feed]) -> Void) {
        
        var objects = [Feed]()
        
        objects.append(Feed(amount: error.localizedDescription, details: "Сбой!", comment: "Ошибка загрузки данных", categoryName: "", happened_at: ""))
        
        callback(objects)
        
    }
    
    func dateStringFromUnixTime(unixTime: Int) -> String {
        
        let date = NSDate(timeIntervalSince1970: Double(unixTime))
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone()
        let localDate = dateFormatter.stringFromDate(date)
        
        return localDate
        
    }
    
    

}

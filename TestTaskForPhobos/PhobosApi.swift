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
import CoreData

class PhobosApi {
    
    let url = "http://mobile165.hr.phobos.work/list"
    
    func fetchObjectsFromServer(callback: ([NSManagedObject], connectError: NSError?) -> Void) {
        
        request(.GET, url).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.populateObjects(json, callback: callback)
            case .Failure(let error):
                callback([], connectError: error)
            }
        }
        
    }
    
    func fetchObjectsFromCache(callback: ([NSManagedObject]) -> Void) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Feed")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
                callback(fetchedResults)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    func populateObjects(json: JSON, callback: ([NSManagedObject], connectError: NSError?) -> Void) {
        
        var objects = [NSManagedObject]()
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Feed",                                           inManagedObjectContext: managedContext)
        
        
        for var i = 3; i <= 5; i += 1 {
        
            for feed in json["feed"]["2014-04-1\(i)"].arrayValue {
            
                let feedEntity =  NSManagedObject(entity: entity!,
                                            insertIntoManagedObjectContext:managedContext)
                
                if !containsObjectInCache(feed) {
                
                    feedEntity.setValue(feed["id"].stringValue, forKey: "id")
                    feedEntity.setValue(feed["money"]["amount"].stringValue + " RUB", forKey: "amount")
                    feedEntity.setValue(feed["details"].stringValue, forKey: "details")
                    feedEntity.setValue(feed["comment"].stringValue, forKey: "comment")
                    feedEntity.setValue("Категория: " + feed["category"]["name"].stringValue, forKey: "categoryName")
                    feedEntity.setValue(dateStringFromUnixTime(feed["happened_at"].intValue), forKey: "happened_at")
                
                
                    do {
                    
                        try feedEntity.managedObjectContext?.save()
                    
                    } catch {
                        let fetchError = error as NSError
                        print(fetchError)
                    }
                    
                
                    objects.append(feedEntity)
                }
                
            }
        
        }
        
        callback(objects, connectError: nil)
        
    }
    
    func containsObjectInCache(feed: JSON) -> Bool {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Feed")
        
        let predicate1 = NSPredicate(format:"id == %@", feed["id"].stringValue)
        let predicate2 = NSPredicate(format:"happened_at == %@", dateStringFromUnixTime(feed["happened_at"].intValue))
        let compound = NSCompoundPredicate.init(andPredicateWithSubpredicates: [predicate1, predicate2])
        
        fetchRequest.predicate = compound
        
        var fetchedResults: [NSManagedObject] = []
        
        do {
            
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
        } catch {
            
            let fetchError = error as NSError
            print(fetchError)
            
        }
        
        if !fetchedResults.isEmpty {
            return true
        } else {
            return false
        }

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

//
//  AddShedViewController.swift
//  TaskIt2
//
//  Created by Yakov on 07/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit
import CoreData

class AddShedViewController: UIViewController {

  
    @IBOutlet weak var nameShed: UITextField!
    
    @IBOutlet weak var addScheduleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScheduleButton.enabled = false
        addScheduleButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func changeTextSchedule(sender: UITextField) {
        
        if nameShed.text == "" {
            
            
            addScheduleButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            addScheduleButton.enabled = false
            
        } else {
            addScheduleButton.enabled = true
            addScheduleButton.setTitleColor(UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0), forState: UIControlState.Normal)
        }
        
        
    }
    @IBAction func doneTapped(sender: UIButton) {
        
        var shedArray: [String] = []
        //get schedule array
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "TaskModel")
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try managedObjectContext.executeFetchRequest(request)
            
            for res in results {
                let schedule = res.valueForKey("schedule") as! String
                if !shedArray.contains(schedule) && schedule != ""
                {
                    shedArray.append(schedule)
                    
                }
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        ///proverka
        if shedArray.contains(nameShed.text!)  {
            
            let alert = UIAlertController(title: "This name is exist!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)

            
        } else if nameShed.text == "" {
        
            let alert = UIAlertController(title: "Empty name!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate
            as? AppDelegate)?.managedObjectContext {
                ///add new 
                //////////////
                let predicate = NSPredicate(format: "schedule == %@", "")
                
                let fetchRequest = NSFetchRequest(entityName: "TaskModel")
                fetchRequest.predicate = predicate
                
                do {
                    let fetchedEntities = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TaskModel]
                    
                    for entity in fetchedEntities {
                    
                        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
    
                        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                    
                        task.task     = entity.task
                        task.date     = entity.date
                        task.order    = entity.order
                        task.schedule = nameShed.text
                        
                    }
                } catch {
                    // Do something in response to error condition
                }
                
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Save failed: \(error.localizedDescription)")
                }
                
        }
        
        self.dismissViewControllerAnimated(true, completion: nil) }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

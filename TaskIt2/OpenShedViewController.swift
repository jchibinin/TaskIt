//
//  OpenShedViewController.swift
//  TaskIt2
//
//  Created by Yakov on 08/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit
import CoreData

class OpenShedViewController: UIViewController {

    var shedText: String = ""
    var shedArray: [String]=[]
    
    @IBOutlet weak var sheduleLabelText: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        //get schedule array
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
        
        doneButton.enabled = false
        doneButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(sender: UIButton) {
     
        //clearing
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate
            as? AppDelegate)?.managedObjectContext {
                ///clear all
                //////////////
                var predicate = NSPredicate(format: "schedule == %@", "")
                
                var fetchRequest = NSFetchRequest(entityName: "TaskModel")
                fetchRequest.predicate = predicate
                
                do {
                    let fetchedEntities = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TaskModel]
                    
                    for entity in fetchedEntities {
                        managedObjectContext.deleteObject(entity)
                    }
                } catch {
                    // Do something in response to error condition
                }
                
                do {
                    try managedObjectContext.save()
                } catch {
                    // Do something in response to error condition
                }
               
                ///add in new
                //////////////
                predicate = NSPredicate(format: "schedule == %@", shedText)
                
                fetchRequest = NSFetchRequest(entityName: "TaskModel")
                fetchRequest.predicate = predicate
                
                do {
                    let fetchedEntities = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TaskModel]
                    
                    for entity in fetchedEntities {
                        
                        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
                        
                        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
                        
                        task.task     = entity.task
                        task.date     = entity.date
                        task.order    = entity.order
                        task.schedule = ""
                        task.notify   = entity.notify
                        
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
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
       
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }
    
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shedArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shedArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shedText = shedArray[row]
        sheduleLabelText.text = shedText
        doneButton.enabled = true
        doneButton.setTitleColor(UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0), forState: UIControlState.Normal)    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

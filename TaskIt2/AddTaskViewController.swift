//
//  AddTaskViewController.swift
//  TaskIt2
//
//  Created by Yakov on 25/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
  
    @IBOutlet weak var dueDatePicker: UIDatePicker!
   
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var addButtonButton: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.date = Date.from("00:05")
        addButtonButton.enabled = false
        addButtonButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func taskChanged(sender: UITextField) {
        
        if taskTextField.text == "" {
            
            
            addButtonButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            addButtonButton.enabled = false
       
        } else {
            addButtonButton.enabled = true
             addButtonButton.setTitleColor(UIColor(red:255/255, green:102/255, blue:102/255, alpha:1.0), forState: UIControlState.Normal)
        }
        
    }
    @IBAction func cancelButtonTapped(sender: UIButton) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addTaskButtonTapped(sender: UIButton) {
       
       // var task = TaskModel(task: taskTextField.text!, date: dueDatePicker.date)
       // mainVC.taskArray.append(task)
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
        
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        task.task = taskTextField.text!
        task.date = dueDatePicker.date
        task.order = task.lastMaxPosition() + 1
        task.schedule = ""
        task.notify = notificationSwitch.on
        
        appDelegate.saveContext()
        
        let request = NSFetchRequest(entityName: "TaskModel")
        request.returnsObjectsAsFaults = false
        
        do {
        let results: NSArray = try managedObjectContext.executeFetchRequest(request)
        
        for res in results {
            print(res)
        }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}

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

    //var mainVC: ViewController!
    
    @IBOutlet weak var taskTextField: UITextField!
   // @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    ///2.16
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDatePicker.date = Date.from("00:05")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "TaskModel")
        
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

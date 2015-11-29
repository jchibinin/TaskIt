//
//  TaskDetailViewController.swift
//  TaskIt2
//
//  Created by Yakov on 20/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var detailTaskModel: TaskModel!
    
    //var mainVC: ViewController!
    
  //  @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var taskTexField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTexField.text = detailTaskModel.task
        self.dueDatePicker.date = detailTaskModel.date!
        
       
    }

    @IBAction func textChanged(sender: UITextField) {
    
        if taskTexField.text == "" {
         
           doneButton.enabled = false
            
        } else
        {
            doneButton.enabled = true
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        
        //var task = TaskModel(task: taskTexField.text!, date: dueDatePicker.date)
        
        //mainVC.taskArray[(mainVC.currentIndexPath.row)] = task
        
        let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
        detailTaskModel.task = taskTexField.text
        detailTaskModel.date = dueDatePicker.date
        
        appDelegate.saveContext()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

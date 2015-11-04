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
    
    var mainVC: ViewController!
    
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var taskTexField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskTexField.text = detailTaskModel.task
        self.subtaskTextField.text = detailTaskModel.subtask
        self.dueDatePicker.date = detailTaskModel.date
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }

    @IBAction func doneBarButtonItemTapped(sender: UIBarButtonItem) {
        
        var task = TaskModel(task: taskTexField.text!, subtask: subtaskTextField.text!, date: dueDatePicker.date)
        
        mainVC.taskArray[(mainVC.currentIndexPath.row)] = task
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

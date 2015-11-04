//
//  AddTaskViewController.swift
//  TaskIt2
//
//  Created by Yakov on 25/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    var mainVC: ViewController!
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    ///2.16
    override func viewDidLoad() {
        super.viewDidLoad()

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
       
        var task = TaskModel(task: taskTextField.text!, subtask: subtaskTextField.text!, date: dueDatePicker.date)
        mainVC.taskArray.append(task)
        
        //?
        //mainVC.tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}

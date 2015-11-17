//
//  OpenShedViewController.swift
//  TaskIt2
//
//  Created by Yakov on 08/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class OpenShedViewController: UIViewController {

    var mainVC: ViewController!
    var shedText: String = ""
    var taskArray: [TaskModel]=[]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //    pickerView.dataSource = self
   //    pickerView.delegate = self
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
        
       // var index: Int = 0
        for shed in mainVC.shedArray {
            
            if shed.shedName == shedText {
                
                mainVC.taskArray.removeAll()
                mainVC.taskArray.appendContentsOf(shed.taskArray)
                
            }
       //     index++
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }
    
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainVC.shedArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainVC.shedArray[row].shedName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shedText = mainVC.shedArray[row].shedName
        taskArray = mainVC.shedArray[row].taskArray
    }

    ////table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = taskArray[indexPath.row]
        
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! TaskCell
        
        cell.taskLabel.text = thisTask.task
        cell.dateLabel.text = Date.toString(date: thisTask.date!)
        
        // cell.showsReorderControl = true
        
        return cell
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

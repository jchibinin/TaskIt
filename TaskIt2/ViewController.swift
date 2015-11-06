//
//  ViewController.swift
//  TaskIt2
//
//  Created by Yakov on 18/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    
    var timeBegin: NSDate = NSDate.init()
    var timeEnd: NSDate = NSDate.init()
    var from: Bool = Bool.init()
    
    var taskArray:[TaskModel]=[]
    var shedArray:[ShedModel]=[]
    var currentShed: ShedModel = ShedModel(shedName: "", taskArray: [])
    var currentIndexPath: NSIndexPath = NSIndexPath.init()
    var timer: NSTimer = NSTimer.init()
    
    var activeTask: Int = 0
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let date1 = Date.from("00:23")
        let date2 = Date.from("00:10")
        let date3 = Date.from("00:15")
        
        let task1 = TaskModel(task: "Дорога на работу", date: date1)
        let task2 = TaskModel(task: "Еда", date: date2)
        
        taskArray = [task1, task2, TaskModel(task: "Утренние процедуры", date: date3)]
        
        ////
        from = true
        let shed1 = ShedModel(shedName: "Morning", taskArray: taskArray)
        shedArray.append(shed1)
        //
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("myHandler"), userInfo: nil, repeats: true)
        
        self.tableView.reloadData()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //compute second date
       
        var tasksSeconds:Int = 0
        
        for task in taskArray {
            tasksSeconds = tasksSeconds + Date.toIntSec(date: task.date)
            }
        
        if from {
         timeEnd = timeBegin.dateByAddingTimeInterval(Double(tasksSeconds))
        }else{
         timeBegin = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds))
        }
        
        
        self.tableView.reloadData()
        
        if timer.valid == false{
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("myHandler"), userInfo: nil, repeats: true)
        }
    }
    
    //timer
    func myHandler() {
       
        if editButton.tag == 100 {
        
        var tasksSeconds:Int = 0
        var taskSeconds:Int = 0
        var timeEndTask, timeBeginTask: NSDate
        var currentTime: NSDate = NSDate.init()
        var index:Int = 0
        var dateComparisionResultEnd:NSComparisonResult
        var dateComparisionResultBegin:NSComparisonResult
        var secsToEndTask: Int
        var cellText: String = ""
        var lastActiveTask: Int = activeTask
        
        for task in taskArray {
            timeEndTask = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds))
            taskSeconds = Date.toIntSec(date: task.date)
            timeBeginTask = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds+taskSeconds))
            dateComparisionResultEnd = currentTime.compare(timeEndTask)
            dateComparisionResultBegin = currentTime.compare(timeBeginTask)
            cellText = ""
            // set active tasks
            if dateComparisionResultEnd == NSComparisonResult.OrderedAscending &&
                dateComparisionResultBegin == NSComparisonResult.OrderedDescending {
                activeTask = index
                //skolko sek ostalos
                //time end task - current time
                secsToEndTask = Date.toIntSec(date: task.date) - Int(NSDate().timeIntervalSinceDate(timeBeginTask))
                let minutes = Int(secsToEndTask/60)
                let cellText = String(format:"%d:%02d", minutes, secsToEndTask - minutes*60)
               ///update cell
                    let indexPath: NSIndexPath = NSIndexPath(forItem: activeTask, inSection: 0)
                    let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
                    cell.descriptionLabel.text = cellText

            } else {
                
                let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
                let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
               // if cell.descriptionLabel.text != "" {
                    cell.descriptionLabel.text = ""
               // }
            }
            
            tasksSeconds = tasksSeconds + taskSeconds
            index = index+1
        }
        }
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        
         if segue.identifier == "showTaskDetail" {
            
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            
            let indexPath = currentIndexPath //self.tableView.indexPathForSelectedRow!
            let thisTask = taskArray[indexPath.row]
            
            detailVC.detailTaskModel = thisTask
            detailVC.mainVC = self
         }
         else if segue.identifier == "showTaskAdd" {
            
            let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            
            addTaskVC.mainVC = self
            
         } else if segue.identifier == "showProperties" {
            
            let propertiesVC: PropertiesViewController = segue.destinationViewController as! PropertiesViewController
            
            propertiesVC.mainVC = self
            
        }
        
    }
    
    @IBAction func propetiesButtonTapped(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("showProperties", sender: self)
        
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
     
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
        timer.invalidate()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    //UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskArray.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = taskArray[indexPath.row]
        
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! TaskCell
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = ""
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        
       // cell.showsReorderControl = true
        
        return cell
    }
    
    //time show
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        var direction: String = ""
        if  !from {
         direction = " ↓"
        }
        
        title = Date.toStringLong(date: timeEnd) + direction
        return title
        
    }
    
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var title: String = ""
        var direction: String = ""
        if  from {
            direction = " ↑"
        }
        
        title = Date.toStringLong(date: timeBegin) + direction
        return title
    
    }

    
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //   performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    //////////////// swipe
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            
            self.taskArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {action in
            
            self.currentIndexPath = indexPath
            self.performSegueWithIdentifier("showTaskDetail", sender: self)
            
        }
        
        return [deleteAction, editAction]
    }
    
    ///////////// mooving
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
    
        if (self.editButton!.tag == 100)
        {
            self.tableView?.setEditing(true, animated: true)
            self.editButton!.tag = 200
            self.editButton.title = "Done"
        }
        else
        {
            self.tableView?.setEditing(false, animated: true)
            self.editButton!.tag = 100
            self.editButton.title = "Edit"
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
       
        tableView.beginUpdates()
        
        taskArray.insert(taskArray.removeAtIndex(sourceIndexPath.row), atIndex: destinationIndexPath.row)
        self.tableView?.moveRowAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        
        tableView.endUpdates()
        
        
    }
   }


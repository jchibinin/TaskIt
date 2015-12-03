//
//  ViewController.swift
//  TaskIt2
//
//  Created by Yakov on 18/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

   
    @IBOutlet weak var tableView: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    var currentIndexPath: NSIndexPath = NSIndexPath.init()
    
    var timer: NSTimer = NSTimer.init()
    var activeTask: Int = 0
    
    //temp task array
    var taskArray:[NSDate]=[]
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var notificationFinish: Bool {
    get {
    var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("notificationFinish") as? Bool
    if returnValue == nil {
    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "notificationFinish")
    NSUserDefaults.standardUserDefaults().synchronize()
    returnValue = true
    }
    return returnValue!
    }
    set (newValue) {
    NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "notificationFinish")
    NSUserDefaults.standardUserDefaults().synchronize()
    }
    }
    
    
    //////////saving settings
    var from : Bool {
        get {
            var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("from") as? Bool
            if returnValue == nil {
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: "from")
                NSUserDefaults.standardUserDefaults().synchronize()
                returnValue = true
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "from")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var timeEnd: NSDate {
        get {
            var returnValue: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey("timeEnd") as? NSDate
            if returnValue == nil {
                NSUserDefaults.standardUserDefaults().setObject(NSDate.init(), forKey: "timeEnd")
                NSUserDefaults.standardUserDefaults().synchronize()
                returnValue = NSDate.init()
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "timeEnd")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var timeBegin: NSDate {
        get {
            var returnValue: NSDate? = NSUserDefaults.standardUserDefaults().objectForKey("timeBegin") as? NSDate
            if returnValue == nil {
                NSUserDefaults.standardUserDefaults().setObject(NSDate.init(), forKey: "timeBegin")
                NSUserDefaults.standardUserDefaults().synchronize()
                returnValue = NSDate.init()
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "timeBegin")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    /////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchedResultController = getFetchedResultsController()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        //notification setup
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        updateTimeEndBegin()
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)
        updateTimeEndBegin()
        updateNotifications()
        tableView.reloadData()
        
    }
    
    
    ///////////////////////////////notification///////////////////////
    
    func updateNotifications(){
        //proverki na
        guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
        if settings.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        ///clear all notifications
        
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            //let userInfoCurrent = notification.userInfo! as! [String:AnyObject]
           // let uid = userInfoCurrent["intime"]! as String
           // if uid == uidtodelete {
                //Cancelling local notification
                app.cancelLocalNotification(notification)
         //       break;
           // }
        }
        
        //proverka na konechnuyu datu
        let currentTime: NSDate = NSDate.init()
        let dateComparisionResultEnd = currentTime.compare(timeEnd)
        if dateComparisionResultEnd == NSComparisonResult.OrderedAscending {
            //ustanovim datu orinchaniya
            if notificationFinish && taskArray.count>0 {
                
                let notification = UILocalNotification()
                notification.fireDate = timeEnd
                notification.alertBody = "Time over! Schedule finished"
                notification.alertAction = "check"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["CustomField1": "intime"]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            }
            
            var tasksSeconds:Int = 0
            var dateTime: NSDate
            var notify: Bool
            var task: String
           
            var taskTime: NSDate
            
            
            let request = taskFetchRequest()
            request.returnsObjectsAsFaults = false
         
            do {
                let results: NSArray = try managedObjectContext.executeFetchRequest(request)
                
                for res in results {
                    
                    dateTime = res.valueForKey("date") as! NSDate
                    notify = res.valueForKey("notify") as! Bool
                    task = res.valueForKey("task") as! String
                    
                    
                    tasksSeconds = tasksSeconds + Date.toIntSec(date: dateTime)
                    taskTime = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds))
                    let dateComparisionResultTask = currentTime.compare(taskTime)
                    
                    if notify && dateComparisionResultTask == NSComparisonResult.OrderedAscending {
                    
                        let notification = UILocalNotification()
                        notification.fireDate = taskTime
                        notification.alertBody = "Task start " + task
                        notification.alertAction = "check it"
                        notification.soundName = UILocalNotificationDefaultSoundName
                        notification.userInfo = ["CustomField1": "w00t"]
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        
                        
                    }

                    
                    
                }
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
            
   
            
            
            
        }
        
    }
    ////////////////////////////////////////////////////////////
    func updateTimeEndBegin()
    {
    
        var tasksSeconds:Int = 0
        //sum of secs
        let request = taskFetchRequest()
        request.returnsObjectsAsFaults = false
        taskArray.removeAll()
        do {
            let results: NSArray = try managedObjectContext.executeFetchRequest(request)
            
            for res in results {
                
               taskArray.append(res.valueForKey("date") as! NSDate)
            
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    
        
        for task in taskArray {
            
            tasksSeconds = tasksSeconds + Date.toIntSec(date: task)
        
        }
        
        if from {
         timeEnd = timeBegin.dateByAddingTimeInterval(Double(tasksSeconds))
        }else{
         timeBegin = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds))
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("myHandler"), userInfo: nil, repeats: true)

    
    }
    
    //timer
    func myHandler() {
       
     
        
        var tasksSeconds:Int = 0
        var taskSeconds:Int = 0
        var timeEndTask, timeBeginTask: NSDate
        let currentTime: NSDate = NSDate.init()
        var index:Int = 0
        var dateComparisionResultEnd:NSComparisonResult
        var dateComparisionResultBegin:NSComparisonResult
        var secsToEndTask: Int
        var cellText: String = ""
    //    let lastActiveTask: Int = activeTask
        
        for task in taskArray {
            timeEndTask = timeEnd.dateByAddingTimeInterval(-Double(tasksSeconds))
            taskSeconds = Date.toIntSec(date: task)
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
                secsToEndTask = Date.toIntSec(date: task) - Int(NSDate().timeIntervalSinceDate(timeBeginTask))
                let minutes = Int(secsToEndTask/60)
                if secsToEndTask != 1 {
                    cellText = String(format:"%d:%02d", minutes, secsToEndTask - minutes*60)
                }
               ///update cell
                let indexPath: NSIndexPath = NSIndexPath(forItem: activeTask, inSection: 0)
                let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
                    
                    cell.descriptionLabel.text = cellText

            //} else {
       
                // kosyak?
            
              // if self.tableView.isAccessibilityElement {
             //   let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
             //   let emtyCell: TaskCell = self.tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
            //        emtyCell.descriptionLabel.text = ""
             //  }
              
            }
            
            tasksSeconds = tasksSeconds + taskSeconds
            index = index+1
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
            let thisTask = fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
            
            detailVC.detailTaskModel = thisTask
          
         }
         else if segue.identifier == "showTaskAdd" {
            
          //  let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            
            
         } else if segue.identifier == "showSetTime" {
            
            let propertiesVC: PropertiesViewController = segue.destinationViewController as! PropertiesViewController
            propertiesVC.mainVC = self
            
         }         
    }
    //properties not used
    //@IBAction func propetiesButtonTapped(sender: UIBarButtonItem) {
        
      //  self.performSegueWithIdentifier("showProperties", sender: self)
      //  timer.invalidate()
   // }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
     
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
        timer.invalidate()
    }
    
    //UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
      return fetchedResultController.sections!.count
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultController.sections![section].numberOfObjects
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
        
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! TaskCell
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = ""
        cell.dateLabel.text = Date.toString(date: thisTask.date!)
        cell.alarmImage.hidden = !thisTask.notify
        return cell
    }
    
    //time show
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    
  /*
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String = ""
        var direction: String = ""
        if  !from {
         direction = " ↓"
        }
        
        title = Date.toStringLong(date: timeEnd) + direction
        return title
        
    }
   */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        var title: String = ""
        var direction: String = ""
        if  !from {
            direction = " ↓"
        }
        
        title = Date.toStringLong(date: timeEnd) + direction
        //return title
        
        let label : UILabel = UILabel()
        label.textColor =  UIColor.darkGrayColor()
        label.backgroundColor = UIColor.groupTableViewBackgroundColor()
        //label.textAlignment =
        label.text = "   "+title
   
        return label
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var title: String = ""
        var direction: String = ""
        if  from {
            direction = " ↑"
        }
        
        title = Date.toStringLong(date: timeBegin) + direction
        
        let label : UILabel = UILabel()
        label.textColor =  UIColor.darkGrayColor()
        label.backgroundColor = UIColor.groupTableViewBackgroundColor()
        //label.textAlignment =
        label.text = "   "+title
        
        return label
        
    }
    
  /*  func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var title: String = ""
        var direction: String = ""
        if  from {
            direction = " ↑"
        }
        
        title = Date.toStringLong(date: timeBegin) + direction
        return title
    
    }*/
    
    //UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     //   performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    //////////////// swipe
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    ///edit delete
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style:
            UITableViewRowActionStyle.Default, title: "Delete",handler: { (action,
                indexPath) -> Void in
                // Delete the row from the database
                if let managedObjectContext = (UIApplication.sharedApplication().delegate
                    as? AppDelegate)?.managedObjectContext {
                        let itemToDelete =
                        self.fetchedResultController.objectAtIndexPath(indexPath) as! TaskModel
                        managedObjectContext.deleteObject(itemToDelete)
                        do {
                            try managedObjectContext.save()
                            tableView.reloadData()
                        } catch {
                            print(error)
                        }
                }
               
        })
        
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
            //timer.invalidate()
        }
        else
        {
            self.tableView?.setEditing(false, animated: true)
            self.editButton!.tag = 100
            self.editButton.title = "Edit"
          //  timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("myHandler"), userInfo: nil, repeats: true)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        self.tableView.beginUpdates()
        
        if var todos = self.fetchedResultController.fetchedObjects {
            let todo = todos[sourceIndexPath.row] as! TaskModel
            todos.removeAtIndex(sourceIndexPath.row)
            todos.insert(todo, atIndex: destinationIndexPath.row)
            
            var idx : Int32 = Int32(todos.count)
            for todo in todos as! [TaskModel] {
                todo.order = idx--
            }
            
            
            saveContext()
        }
        
       dispatch_async(dispatch_get_main_queue(), { () -> Void in
                tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows!, withRowAnimation: UITableViewRowAnimation.Fade)
        })
            
        
        self.tableView.endUpdates()
        
    }
    
    ///helper
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDecriptor = NSSortDescriptor(key: "order", ascending: false)
        let predicate = NSPredicate(format: "schedule == %@", "")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDecriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
       
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
   

func saveContext() {
    
   // let context = getFetchedResultsController() .managedObjectContext
    let context = self.fetchedResultController.managedObjectContext
   
    do {
        try context.save()

        } catch let error as NSError {
        // failure
        print("Save failed: \(error.localizedDescription)")
    }
    
}
    
   func controllerDidChangeContent(controller: NSFetchedResultsController)
   {
    
    updateTimeEndBegin()
    tableView.reloadData()
   
}
///////////////////buttons
    
    @IBAction func barCleanButtonTapped(sender: UIBarButtonItem) {
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate
            as? AppDelegate)?.managedObjectContext {
                ///clear all
                //////////////
                let predicate = NSPredicate(format: "schedule == %@", "")
                
                let fetchRequest = NSFetchRequest(entityName: "TaskModel")
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
                ///////////////
                
        }
        
    }
    
    @IBAction func barSaverButtonTapped(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Save", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "in new", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in self.saveInNew()}))
        
        //proverka
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
        if shedArray.count > 0 {        alert.addAction(UIAlertAction(title: "in exist", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in self.saveInExist()}))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    
    @IBAction func barLoadButtonTapped(sender: UIBarButtonItem) {
        
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
        if shedArray.count > 0 {
            self.performSegueWithIdentifier("showOpenShed", sender: self) }
        else {
            
            let alert = UIAlertController(title: "Nothing to load", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func barSetTimeTapped(sender: UIBarButtonItem) {
       
        self.performSegueWithIdentifier("showSetTime", sender: self)
        timer.invalidate()
    }
    ////save func
    
    func saveInNew(){
        
        self.performSegueWithIdentifier("showAddShed", sender: self)
        
    }
    
    
    func saveInExist(){
        
        self.performSegueWithIdentifier("showSaveShed", sender: self)
        
    }
}

//
//  PropertiesViewController.swift
//  TaskIt2
//
//  Created by Yakov on 02/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit
import CoreData

class PropertiesViewController: UIViewController {

    var mainVC: ViewController!
    
    @IBOutlet weak var dueDate: UIDatePicker!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if mainVC.from {
           segmentControl.selectedSegmentIndex = 0
           self.dueDate.date = mainVC.timeBegin
        } else {
            segmentControl.selectedSegmentIndex = 1
            self.dueDate.date = mainVC.timeEnd
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func doneTapped(sender: UIButton) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            mainVC.from = true
            mainVC.timeBegin = self.dueDate.date
        case 1:
            mainVC.from = false
            mainVC.timeEnd = self.dueDate.date
        default:
            break; 
        }
       
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //shedule actions
    @IBAction func newSheduleTapped(sender: UIButton) {
        
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
               
        }    }
    
    
    @IBAction func saveSheduleTapped(sender: AnyObject) {
    
        var alert = UIAlertController(title: "Save", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "in new", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in self.saveInNew()}))
        alert.addAction(UIAlertAction(title: "in exist", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in self.saveInExist()}))
        self.presentViewController(alert, animated: true, completion: nil)
      
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func saveInNew(){
        
        self.performSegueWithIdentifier("showAddShed", sender: self)

    }

    
    func saveInExist(){
        
        self.performSegueWithIdentifier("showSaveShed", sender: self)
        
    }
    
    @IBAction func loadSheduleTapped(sender: UIButton) {
    
        self.performSegueWithIdentifier("showOpenShed", sender: self)
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAddShed" {
            
            let addShedVC: AddShedViewController = segue.destinationViewController as! AddShedViewController
            
        
            
        } else if segue.identifier == "showSaveShed" {
            
            let propertiesVC: SaveShedViewController = segue.destinationViewController as! SaveShedViewController
            
           
            
        } else if segue.identifier == "showOpenShed" {
            
            
            let loadVC: OpenShedViewController = segue.destinationViewController as! OpenShedViewController
            
            
            
        }
    }
}

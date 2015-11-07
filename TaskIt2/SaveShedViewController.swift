//
//  SaveShedViewController.swift
//  TaskIt2
//
//  Created by Yakov on 07/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class SaveShedViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var mainVC: ViewController!
    var shedText: String = ""
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
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
        var index: Int = 0
        for shed in mainVC.shedArray {
            if shed.shedName == shedText {
                
                mainVC.shedArray.removeAtIndex(index)
                
                var newShed: ShedModel = ShedModel(shedName: "", taskArray: [])
                newShed.taskArray = mainVC.taskArray
                newShed.shedName = shedText
                mainVC.shedArray.insert(newShed, atIndex: index)

            }
            index++
        }
        
        
         self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainVC.shedArray.count
    }
    
    //func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       // return mainVC.shedArray[row].shedName
    //    return "item"
    //}
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mainVC.shedArray[row].shedName
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shedText = mainVC.shedArray[row].shedName
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

//
//  AddShedViewController.swift
//  TaskIt2
//
//  Created by Yakov on 07/11/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class AddShedViewController: UIViewController {

    var mainVC: ViewController!
  
    @IBOutlet weak var nameShed: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let shed1 = ShedModel(shedName: nameShed.text!, taskArray: mainVC.taskArray)
        mainVC.shedArray.append(shed1)
        mainVC.currentShed = shed1
        self.dismissViewControllerAnimated(true, completion: nil)
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

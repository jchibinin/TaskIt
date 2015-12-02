//
//  TaskCell.swift
//  TaskIt2
//
//  Created by Yakov on 18/10/15.
//  Copyright © 2015 Bitfoundation. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var alarmImage: UIImageView!
    
    //@IBOutlet weak var notifyLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // let image = UIImage(named: "hello.png")
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

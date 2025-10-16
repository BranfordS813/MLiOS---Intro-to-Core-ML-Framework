//
//  ViewController.swift
//  Xcode photo picker
//
//  Created by brandonsanford on 10/14/25.
//

import UIKit

class ViewController: UIViewController {
    
    // This is the IBOutlet that connects the label to your code
    @IBOutlet weak var MultiLineLabel1: UILabel!
    
    // Lets create a nother IBOutlet that connects a second label to code
    @IBOutlet weak var MultiLineLabel2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 1. Set the number of lines to 0 (already done in Storyboard, but good to confirm)
        MultiLineLabel1.numberOfLines = 0
        
        // 2. Set the multi-line string using '\n' for line breaks
        MultiLineLabel2.numberOfLines = 0
        MultiLineLabel2.text = "App Developed by: \nBrandon Sanford\n\nThis is a test of a multi-line label. Example of third line entry with \\n"
    }


}


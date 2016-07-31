//
//  ReportViewController.swift
//  BinThere
//
//  Created by Brendan Hodkinson on 31/07/2016.
//  Copyright © 2016 Daniel Richardson. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBAction func full(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        let alert = UIAlertView()
        alert.title = "Report"
        alert.message = "Thank you for reporting this bin"
        alert.addButtonWithTitle("Close")
        alert.show()
    }
    
    @IBAction func vandal(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        let alert = UIAlertView()
        alert.title = "Report"
        alert.message = "Thank you for reporting this bin"
        alert.addButtonWithTitle("Close")
        alert.show()
    }
    
    @IBAction func dogbag(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        let alert = UIAlertView()
        alert.title = "Report"
        alert.message = "Thank you for reporting this bin"
        alert.addButtonWithTitle("Close")
        alert.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

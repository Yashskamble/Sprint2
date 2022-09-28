//
//  NotificationViewController.swift
//  Sprint2
//
//  Created by Capgemini-DA230 on 9/26/22.
//

import UIKit
import MyFramework

class NotificationViewController: UIViewController {

    
    //MARK: Functions
    //Function notification button when clicked it will call function of custom framework named myframework which will fire a notification when the button is clicked.
    @IBAction func localNotificationAction(_ sender: Any) {
        //creating instance of class which is in custom framework
        let framework = YashNotification()
        
        //calling the func which will fire local notification
        framework.localNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notification"
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

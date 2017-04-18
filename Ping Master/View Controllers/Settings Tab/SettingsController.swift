//
//  SettingsController.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/1/16.
//  Copyright © 2016 Nexus Heights. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    // IBOutlets for settings toggles
    @IBOutlet weak var ShowSentMessagesToggle: UISwitch!
    @IBOutlet weak var ShowResponseMessagesToggle: UISwitch!
    @IBOutlet weak var ShowUnexpectedResponseMessagesToggle: UISwitch!
    @IBOutlet weak var ShowTimeoutMessagesToggle: UISwitch!
    @IBOutlet weak var ShowErrorMessagesToggle: UISwitch!
    
    // Save the state of the toggles to the disk and also synchronize them so that closing the app after toggling doesn't
    // make you lose your save
    @IBAction func ShowSentMessagesToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(ShowSentMessagesToggle.on, forKey: "show_sent_messages")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func ShowResponseMessagesToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(ShowResponseMessagesToggle.on, forKey: "show_response_messages")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func ShowUnexpectedResponseMessagesToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(ShowUnexpectedResponseMessagesToggle.on, forKey: "show_unexpected_messages")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func ShowTimeoutMessagesToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(ShowTimeoutMessagesToggle.on, forKey: "show_timeout_messages")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    @IBAction func ShowErrorMessagesToggled(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(ShowErrorMessagesToggle.on, forKey: "show_error_messages")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
    
    
    
    // The default delegate methods for the view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // We need to set the state of all toggles so that they match what is saved in settings
        // We only have to do this once at the load of the view because the view will never get deloaded
        // Also, if the user changes the toggles after the view is loaded, those will be committed so they will remain persistent
        synchronizeToggles()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Functions for going to Social Media Profiles
    
    func synchronizeToggles()
    {
        // Set the state of all toggles in the view to the same ones that are saved to disk
        // This enables settings to persist across app launches and restarts
        ShowSentMessagesToggle.on = NSUserDefaults.standardUserDefaults().boolForKey("show_sent_messages")
        ShowErrorMessagesToggle.on = NSUserDefaults.standardUserDefaults().boolForKey("show_error_messages")
        ShowUnexpectedResponseMessagesToggle.on = NSUserDefaults.standardUserDefaults().boolForKey("show_unexpected_messages")
        ShowTimeoutMessagesToggle.on = NSUserDefaults.standardUserDefaults().boolForKey("show_timeout_messages")
        ShowResponseMessagesToggle.on = NSUserDefaults.standardUserDefaults().boolForKey("show_response_messages")
    }
    
    @IBAction func TwitterButtonPressed(sender: AnyObject){
        // Open Twitter webpage to the Nexus Heights page
        UIApplication.sharedApplication().openURL((NSURL(string: "http://twitter.com/nexus_heights"))!)
    }
    
    @IBAction func InstagramButtonPressed(sender: AnyObject) {
        // Open Instagram webpage to the Nexus Heights page
        UIApplication.sharedApplication().openURL((NSURL(string: "http://instagram.com/nexus_heights"))!)
    }
    
    @IBAction func FacebookButtonPressed(sender: AnyObject) {
        // Open Facebook webpage to the Nexus Heights page
        UIApplication.sharedApplication().openURL((NSURL(string: "http://facebook.com/nexusheights"))!)
    }
}

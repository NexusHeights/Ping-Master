//
//  PingViewController.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/2/16.
//  Copyright © 2016 Nexus Heights. All rights reserved.
//

import UIKit

class PingViewController: UIViewController, GBPingDelegate {
    
    // Set up buttons so we can add a border
    @IBOutlet weak var PingButton: UIButton!
    
    var FirstPress: Bool = true
    
    // The output of the ping function
    @IBOutlet weak var PingTextField: UITextView!
    var ping = GBPing.init()
    // Default device title and IP address - this should never be seen by the user
    var pingDeviceTitle: String = "Device"
    var pingDeviceIP: String = "192.168.0.1"
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        // Set the title in the navigation bar to the device name
        self.title = String(pingDeviceTitle)
        
        // Setup the ping environment and establish necessary socket connections
        setupPing(&ping)
        
        // Set up a border for the text view.
        // NOTE: Strangely, this only seems to be possible through code. Interface Builder does not have controls for this.
        // We have to use Core Graphics to do it.
        PingTextField.layer.borderWidth = 1.0
        PingTextField.layer.borderColor = UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 0/255.0, alpha: 255.0/255.0).CGColor
        PingTextField.layer.cornerRadius = 5.0
        PingButton.layer.borderWidth = 1.0
        PingButton.layer.borderColor = UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 0/255.0, alpha: 255.0/255.0).CGColor
        PingButton.layer.cornerRadius = 5.0
        
        // Set the default ping textview text
        PingTextField.text = "Press ping to begin."
    }

    // All ping delegate methods check the settings before printing anything so that we can disable or enable certain responses
    func ping(pinger: GBPing, didReceiveReplyWithSummary summary: GBPingSummary) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_response_messages") == true
        {
        PingTextField.text = PingTextField.text.stringByAppendingString("Received reply from \(summary.host) that took \(summary.rtt.millisecond.roundToPlaces(3)) milliseconds\n")
        }
    }
    
    func ping(pinger: GBPing, didReceiveUnexpectedReplyWithSummary summary: GBPingSummary) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_unexpected_response_messages") == true
        {
        PingTextField.text = PingTextField.text.stringByAppendingString("Received unexpected reply from \(summary.host) that took \(summary.rtt.millisecond.roundToPlaces(3)) milliseconds\n")
        }
    }
    
    func ping(pinger: GBPing, didSendPingWithSummary summary: GBPingSummary) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_sent_messages") == true
        {
        PingTextField.text = PingTextField.text.stringByAppendingString("Sent ping packet to " + summary.host + "\n")
        }
    }
    
    func ping(pinger: GBPing, didTimeoutWithSummary summary: GBPingSummary) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_timeout_messages") == true
        {
        PingTextField.text = PingTextField.text.stringByAppendingString("Ping packet timed out\n")
        }
    }
    
    func ping(pinger: GBPing, didFailWithError error: NSError) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_error_messages") == true
        {
        PingTextField.text = PingTextField.text.stringByAppendingString("Failed with an error: \(error)\n")
        }
    }
    
    func ping(pinger: GBPing, didFailToSendPingWithSummary summary: GBPingSummary, error: NSError) {
        if NSUserDefaults.standardUserDefaults().boolForKey("show_error_messages") == true
        {
            PingTextField.text = PingTextField.text.stringByAppendingString("Failed with an error: \(error)\n")
        }
    }
    
    func setupPing(inout pinger: GBPing)
    {
        pinger = GBPing.init()
        
        pinger.host = pingDeviceIP
        
        // Set the GBPing delegate to itself
        pinger.delegate = self
        
        // Set the timeout to 1 second
        pinger.timeout = 1.0
        
        // Set the ping period to 0.9 seconds
        pinger.pingPeriod = 0.9
        
        // Setup stuff needed for setupWithBlock
        var success: Bool
        var error: NSError
        
        // This is needed for resolving addresses
        pinger.setupWithBlock { (success, error) in
            if(success)
            {
            }
            else
            {
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Hide the toolbar again incase it somehow didn't hide during the segue from the Device List
        self.navigationController!.toolbar.hidden = true
    }
    
    @IBAction func PingPressed(sender: AnyObject) {
        // Detect if it has been the first time the ping button has been pressed.
        if(FirstPress == true)
        {
            // If so, set the text of the Ping Text UITextView to blank
            PingTextField.text = String()
            FirstPress = false
        }
        
        // Start pinging
        ping.startPinging()
        
    }
}

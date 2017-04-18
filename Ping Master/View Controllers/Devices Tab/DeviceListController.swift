//
//  DeviceListController.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/2/16.
//  Copyright © 2016 Nexus Heights. All rights reserved.
//

import UIKit

class DeviceListController: UITableViewController
{
    var devices = [Device]()
    override func viewDidLoad()
    {
        
        // Add an edit button to the navigation bar
        // This could be done manually through Storyboards, but it would require a lot more code to enable canceling the edit
        navigationItem.leftBarButtonItem = editButtonItem()
        
        
        // Set up sample data if a saved device list does not exist
        if let savedDevices = loadDevices() {
            devices += savedDevices
        } else {
            // Load the sample data.
            loadSampleDevices()
        }
        
        
        // Detect if the keys have been added - if not, set them all to true by default
        setupDefaultKeys()
        
        super.viewDidLoad()
        
        // Unhide toolbar
        self.navigationController!.toolbarHidden = false

    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.toolbar.hidden = false
    }
    
    // A function that will load a sample device into the device list
    func loadSampleDevices()
    {
        // A commonly used router IP that is used as an example
        let router = Device(name: "Router", ip: "192.168.1.1")!
        devices += [router]
    }
    
    func setupDefaultKeys()
    {
        // Set up the default state of all saved settings
        // Update this in the future, at the moment it feels like a shitty way of doing this
        if NSUserDefaults.standardUserDefaults().objectForKey("show_sent_messages") == nil
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "show_sent_messages")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("show_response_messages") == nil
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "show_response_messages")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("show_unexpected_messages") == nil
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "show_unexpected_messages")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("show_timeout_messages") == nil
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "show_timeout_messages")
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("show_error_messages") == nil
        {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "show_error_messages")
        }
        
        // Synchronize so that it sticks
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Always set the number of cells to the number of devices in the device array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return devices.count
    }
    
    // Always set number of sections to 1, as we do not need any more than that
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Function that will generate the cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Set the cell reuse identifier to the same one defined in the storyboard
        let cellIdentifier = "DeviceViewCell"
        
        // Set up a blank cell with the reusable cell identifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Get the device that will exist in the cell by comparing the indexPath row to the device array
        let device = devices[indexPath.row]
        
        // Set the cell header to the device name
        cell.textLabel!.text = device.name
        
        // Set the cell subheader to the device IP address
        cell.detailTextLabel!.text = device.ip
        
        // Return the cell so it can be displayed
        return cell
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveDevices()
    {
        // Save the device list to the local app storage
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(devices, toFile: Device.ArchiveURL!.path!)
        if !isSuccessfulSave {
        }
    }
    
    func loadDevices() -> [Device]? {
        // Return the devices from local app storage into the device array
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Device.ArchiveURL!.path!) as? [Device]
    }
    
    func pushPingView(device: String, _ ip: String)
    {
        // Create a new ping view controller from the storyboard reference
        let controller: PingViewController = storyboard?.instantiateViewControllerWithIdentifier("Ping View") as! PingViewController
        
        // Set the device IP to be passed to the new controller
        controller.pingDeviceIP = ip
        
        // Set the device title to be passed to the new controller
        controller.pingDeviceTitle = device
        
        // Present the ping view controller
        self.showViewController(controller, sender: nil)
    }
    
    // Function that will be ran when the unwind segue runs from AddDeviceViewController
    @IBAction func seguedToDevicesList(sender: UIStoryboardSegue)
    {
        // If the view controller we are moving from is the AddDeviceViewController, do stuff
        if let sourceViewController = sender.sourceViewController as? AddDeviceViewController, let device = sourceViewController.device
        {
            
            // If we are updating an existing device
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                // Update an existing device
                devices[selectedIndexPath.row] = device
                
                // Reload the rows at the indexPath because an update has occurred
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
                
            // We aren't updating an existing device, we are adding one
            else
            {
                // Add a new device
                let newIndexPath = NSIndexPath(forRow: devices.count, inSection: 0)
                
                // Add the new device to the device array
                devices.append(device)
                
                // Insert the new row at the new index path
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the list of devices
            saveDevices()
        }
    }
    
    // This function is ran when any cell is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // Create a cell from the selected cell so we can get it's title and subtitle
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        // Push the ping view with the title and IP of device
        pushPingView((cell.textLabel?.text)!, (cell.detailTextLabel?.text)!)
        
        // Hide the toolbar so that it instantly disappears when going to the Ping View
        self.navigationController!.toolbar.hidden = true
    }
    
    // Allow deleting items in the table view
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Remove the device from the devices array
            devices.removeAtIndex(indexPath.row)
            
            // Commit the list of devices to disk
            saveDevices()
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Allow deleting from the table
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

}

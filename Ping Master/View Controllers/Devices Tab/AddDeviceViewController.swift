//
//  AddDeviceViewController.swift
//  Ping Master
//
//  Created by Gregory Stanton on 4/2/16.
//  Copyright © 2016 Nexus Heights. All rights reserved.
//

import UIKit

class AddDeviceViewController: UIViewController, UITextFieldDelegate {

    // Setup outlets
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var IPField: UITextField!
    
    // Create a new empty Device object
    var device: Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate of the IP text field to this view controller
        IPField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Dismiss keyboard when any touch input is registered
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === AddButton
        {
            // Set name from TitleField
            let name = TitleField.text
            
            // Set IP address from IP field
            let ip = IPField.text
            
            // Create a new Device object from existing device object
            device = Device(name: name!, ip: ip!)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // We need this function to remove the possibility of the user entering/pasting in shit that isn't supposed to be entered into a IP field (assuming the user is on iPad)
        // Also, limit the number of characters that are possible to enter.
        
        // Get the number of characters currently entered into the text field
        let currentCharacterCount = textField.text?.characters.count ?? 0
        
        // Reject if length and location is greater than the current character count
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        // Get the character count and save it to a variable
        let CharacterCount = currentCharacterCount + string.characters.count - range.length
        
        // Set up the set of characters we should use for the text field
        let AllowedCharSet = NSCharacterSet(charactersInString:".0123456789").invertedSet
        
        // Separate the characters by characters in the AllowedCharSet, removing any character that isn't the allowed ones
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(AllowedCharSet)
        
        // Set the FilteredString to the complete joined string
        let FilteredString = compSepByCharInSet.joinWithSeparator("")
        
        // If character count is less than 15, update what is in the text field
        if(CharacterCount <= 15)
        {
            return string == FilteredString
        }
        return false;
        
    }

}

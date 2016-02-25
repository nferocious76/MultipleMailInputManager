//
//  AddressMailManager.swift
//  CustomMailer
//
//  Created by Neil Francis Hipona on 25/02/2016.
//  Copyright © 2016 David McKinney. All rights reserved.
//

import Foundation
import UIKit

protocol AddressMailManagerReceiverDelegate: NSObjectProtocol {
    
    func willAddEmailAddress(manager: AddressMailManager)
    func willRemoveEmailAddress(manager: AddressMailManager)
    func didReloadEmailAddressData(manager: AddressMailManager)
}

protocol AddressMailManagerDelegate: NSObjectProtocol {
    
    func willAddEmailAddressFromAddressInputCell(addressInput: AddressInputCell, emailAddress: String?)
    func willRemoveEmailAddressFromAddressLabelCell(addressLabel: AddressLabelCell)
}

class AddressMailManager: NSObject, UITableViewDelegate, UITableViewDataSource, AddressMailManagerDelegate {
    
    private var tableView: UITableView!
    private let defaultCellHeight: CGFloat = 44.0
    
    var emailAddresses: [String] = []
    
    var addressMailTableHeight: CGFloat {
        get {
            if emailAddresses.count == 0 {
                return defaultCellHeight
            }

            return CGFloat(emailAddresses.count) * defaultCellHeight
        }
    }

    private override init() {
        super.init()
    }
    
    weak var delegate: AddressMailManagerReceiverDelegate!
    
    convenience init(tableView: UITableView, addressMailManagerDelegate: AddressMailManagerReceiverDelegate) {
        self.init(tableView: tableView)
        
        delegate = addressMailManagerDelegate
    }
    
    convenience init(tableView: UITableView) {
        self.init()
        
        self.tableView = tableView
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = defaultCellHeight
        
        let addressLabelNib = UINib(nibName: "AddressLabelCell", bundle: nil)
        tableView.registerNib(addressLabelNib, forCellReuseIdentifier: "AddressLabelCell")
        
        let addressInputNib = UINib(nibName: "AddressInputCell", bundle: nil)
        tableView.registerNib(addressInputNib, forCellReuseIdentifier: "AddressInputCell")

    }

    // MARK: - User Controls
    func addEmailAddress(emailAddress: String) {
        
        emailAddresses.append(emailAddress)
    }
    
    func reloadAddressData() {
        tableView.reloadData()
        
        delegate?.didReloadEmailAddressData(self)
    }
    
    // MARK: - Table Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAddresses.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if emailAddresses.count == indexPath.row {
            let thisCell = tableView.dequeueReusableCellWithIdentifier("AddressInputCell", forIndexPath: indexPath) as! AddressInputCell
            thisCell.cellDelegate = self
            
            return thisCell
        }else{
            let thisCell = tableView.dequeueReusableCellWithIdentifier("AddressLabelCell", forIndexPath: indexPath) as! AddressLabelCell
            
            thisCell.cellDelegate = self
            thisCell.addressLabel.text = emailAddresses[indexPath.row]
            
            return thisCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }

    // MARK: - AddressInputCellDelegate
    
    func willAddEmailAddressFromAddressInputCell(addressInput: AddressInputCell, emailAddress: String?) {
        guard let emailAddress = emailAddress else {
            return
        }
        
        print("Will add email address: \(emailAddress)")

        if !emailAddresses.contains(emailAddress) && isValidEmail(emailAddress) {
            emailAddresses.append(emailAddress)
            
            delegate?.willAddEmailAddress(self)
            
            if let indexPath = tableView.indexPathForCell(addressInput) {
                tableView.beginUpdates()
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView.endUpdates()
            }
        }else{
            print("'\(emailAddress) is not a valid email address.")
        }
    }

    func willRemoveEmailAddressFromAddressLabelCell(addressLabel: AddressLabelCell) {
        guard let emailAddress = addressLabel.addressLabel.text else {
            return
        }
        
        print("Will remove email address: \(emailAddress)")
        
        if let idx = emailAddresses.indexOf(emailAddress) {
            emailAddresses.removeAtIndex(idx)
        }
        
        delegate?.willRemoveEmailAddress(self)

        if let indexPath = tableView.indexPathForCell(addressLabel) {
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
    
    // MARK: - Helpers
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(testStr)
        
    }

}

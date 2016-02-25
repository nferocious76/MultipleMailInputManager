//
//  AddressInputCell.swift
//  CustomMailer
//
//  Created by Neil Francis Hipona on 25/02/2016.
//  Copyright © 2016 David McKinney. All rights reserved.
//

import Foundation
import UIKit

class AddressInputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak private var mainContentView: UIView!
    @IBOutlet weak private var leftPaddingView: UIView!

    @IBOutlet weak var inputField: UITextField!

    var contentBackgroundColor: UIColor = UIColor.grayColor() {
        didSet {
            mainContentView.backgroundColor = contentBackgroundColor
        }
    }
    
    var leftPaddingColor: UIColor = UIColor.blueColor() {
        didSet {
            leftPaddingView.backgroundColor = leftPaddingColor
        }
    }

    weak var cellDelegate: AddressMailManagerDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
        
        inputField.delegate = self
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        
        cellDelegate.willAddEmailAddressFromAddressInputCell(self, emailAddress: textField.text)
        textField.text = ""
        
        return true
    }

}
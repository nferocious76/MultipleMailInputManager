//
//  AddressLabelCell.swift
//  CustomMailer
//
//  Created by Neil Francis Hipona on 25/02/2016.
//  Copyright © 2016 David McKinney. All rights reserved.
//

import Foundation
import UIKit


class AddressLabelCell: UITableViewCell {
    
    @IBOutlet weak private var mainContentView: UIView!
    @IBOutlet weak private var leftPaddingView: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    
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
    }
    
    @IBAction func rightButton(sender: UIButton) {
        
        cellDelegate.willRemoveEmailAddressFromAddressLabelCell(self)
    }
    
}
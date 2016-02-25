//
//  ViewController.swift
//  MultipleMailInputManager
//
//  Created by Neil Francis Hipona on 25/02/2016.
//  Copyright © 2016 NFerocious. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var manager: AddressMailManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = AddressMailManager(tableView: table)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print(manager.emailAddresses)
    }
}


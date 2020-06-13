//
//  ViewController.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/16/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var addTransaction: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTransaction.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }


}


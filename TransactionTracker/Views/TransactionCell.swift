//
//  TransactionCell.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/16/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit


class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionAmt: UILabel!
    
    func configure(t: Transaction){
        self.transactionAmt.text = "Aed\(t.amount)"
        self.transactionName.text = t.name
        totalAmt += Float(t.amount)
    }
 
}

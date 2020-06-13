//
//  AddTransactionVC.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/16/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit

class AddTransactionVC: UIViewController {

    
    @IBOutlet weak var transactionTypeLbl: UITextField!
    @IBOutlet weak var amountLbl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
    }
    @IBAction func addTransactionBtn(_ sender: Any) {
        // here we will save core data
        
        self.save { (complete) in
            if complete{
                print("Data saved successfully!!!")
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                print("Data not saved!!!!")
            }
        }
    }
    
    func save(completion: (_ finished: Bool) ->()){
        //This is how we get managed context object from main queue.
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        //In order to instantiate it prooperly we need to tell the managed object context which model it will be using to create the persistent store coordinator.
        let transaction = Transaction(context: managedContext)
        
        transaction.amount = Float(amountLbl.text!)!
        totalAmt += transaction.amount
        transaction.name = transactionTypeLbl.text
        
        //Till now we have just setup the model, we havent told the managed context object to save it.
        
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("\(error.localizedDescription)")
            completion(false)
        }
    }
}

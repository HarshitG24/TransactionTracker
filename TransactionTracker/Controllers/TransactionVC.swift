//
//  TransactionVC.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/16/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

let appDelegate = UIApplication.shared.delegate as? AppDelegate
var totalAmt: Float = 0.0

class TransactionVC: UIViewController {

    
    var myTransactions: [Transaction] = []
    
    @IBOutlet weak var addTransaction: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.isHidden = true
        addTransaction.isEnabled = false
        
        
        self.authenticateBiometrics { (success) in
            if success{
                DispatchQueue.main.async {
                    self.myTableView.isHidden = false
                    self.addTransaction.isEnabled = true
                }
            }
        }
        
        addTransaction.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchObjects()
        myTableView.reloadData()
        
    }
    
}

extension TransactionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transact", for: indexPath) as? TransactionCell else {return UITableViewCell()}
        
        cell.configure(t: myTransactions[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.removeObject(indexpath: indexPath)
            self.fetchObjects()
            myTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}

extension TransactionVC{ // to fetch...
    
    func fetch(completion: (_ finished: Bool)->()){
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        // We need to tell what will be fetching...
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        
        do{
            myTransactions = try managedContext.fetch(fetchRequest)
            completion(true)
        }catch{
            debugPrint("\(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchObjects(){
        self.fetch { (complete) in
            if complete{
                print("Successfulll!!!")
            }else{
                print("Not sucessfull!!")
            }
        }
    }
}

extension TransactionVC{ // to delete
    
    func removeObject(indexpath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(myTransactions[indexpath.row])
        totalAmt -= myTransactions[indexpath.row].amount
        
        do{
            try managedContext.save()
        }catch{
            print("\(error.localizedDescription)")
        }
    }
}

extension TransactionVC{ // biometrics..
    
    func authenticateBiometrics(completion: @escaping (Bool) -> Void) {
        let myContext = LAContext()
        let myLocalizedReasonString = "Our app uses Touch ID / Face ID to secure your notes."
        var authError: NSError?
        
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { (success, evaluateError) in
                    if success {
                        completion(true)
                    } else {
                        guard let evaluateErrorString = evaluateError?.localizedDescription else { return }
                        self.showAlert(withMessage: evaluateErrorString)
                        completion(false)
                    }
                })
            } else {
                guard let authErrorString = authError?.localizedDescription else { return }
                self.showAlert(withMessage: authErrorString)
                completion(false)
            }
        } else {
            completion(false)
        }
    }
    
    func showAlert(withMessage message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
}


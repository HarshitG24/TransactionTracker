//
//  BiometricVC.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/16/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit
import LocalAuthentication

class BiometricVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.authenticateBiometrics { (success) in
//            if success{
//                guard let vc = storyboard?.instantiateViewController(identifier: "bio") else {return}
//
//                present(vc, animated: true, completion: nil)
//            }else{
//                print("error...")
//            }
//        }
        
    }
    
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

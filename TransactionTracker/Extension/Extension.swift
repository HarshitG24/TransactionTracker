//
//  Extension.swift
//  TransactionTracker
//
//  Created by Harshit Gajjar on 10/17/19.
//  Copyright © 2019 ThinkX. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  ForgotPasswordViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 3.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class ForgotPasswordViewController: CustomViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTouchUpInside(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonTouchUpInside() {
        
        if let email = emailTextField.text {
            
            showBlurView(withBlurEffectStyle: .dark, andCompletion: nil)
            startActivityIndicator()
            
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                self.hideBlurView()
                self.stopActivityIndicator()
                
                if let err = error {
                    ProgressHUD.showError(err.localizedDescription)
                } else {
                    ProgressHUD.showSuccess("Hesabınızı kurtarma maili gönderilmiştir.")
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        
        submitButtonTouchUpInside()
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LoginViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/2/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logIn.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
    }
    // MARK: Buttons Configuration
    
    @IBAction func logInPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                print(error!)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                let dialogMessage = UIAlertController(title: "Error", message: "Email/Password Incorrect", preferredStyle: .alert)
                
                dialogMessage.addAction(ok)
                
                self.present(dialogMessage, animated: true, completion: nil)
                
            }else { // Login Successful!
                
                let userID = Auth.auth().currentUser?.uid
                let ref = Database.database().reference()
                
                // Lookup userID to see if client or artisan, then go to segue
                ref.child("emails").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in

                    let typeValue = snapshot.value! as! Int

                    if typeValue == 1 {
                        self.performSegue(withIdentifier: "clientLoginSegue2", sender: self)
                    }else if typeValue == 2{
                        self.performSegue(withIdentifier: "artisanHomeSegue", sender: self)
                    }
                })
            }
        }
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        performSegue(withIdentifier: "registrationSeque", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

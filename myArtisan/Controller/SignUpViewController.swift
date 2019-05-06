//
//  SignUpViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/2/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var buttonSelected = 0

    // View Fields
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // View Buttons
    @IBOutlet weak var artisan: UIButton!
    @IBOutlet weak var client: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Button border rounding
        client.layer.cornerRadius = 15
        artisan.layer.cornerRadius = 15
        signUp.layer.cornerRadius = 15
    }
    
    @IBAction func clientPressed(_ sender: UIButton) {
        // Client Option Pressed
        if buttonSelected == 2 {
            artisan.backgroundColor = UIColor.clear
        }
        
        buttonSelected = 1
        client.backgroundColor = UIColor.black
    }
    @IBAction func artisanPressed(_ sender: UIButton) {
        // Artisan Option Pressed
        if buttonSelected == 1 {
            client.backgroundColor = UIColor.clear
        }
        
        buttonSelected = 2
        artisan.backgroundColor = UIColor.black
    }
    
    @IBAction func SignUpPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
            if error != nil {
                print()
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                let dialogMessage = UIAlertController(title: "Error", message: "Email already exists", preferredStyle: .alert)
                
                dialogMessage.addAction(ok)
                
                self.present(dialogMessage, animated: true, completion: nil)
            }
            else {  // Registration Successful
                let userID = Auth.auth().currentUser?.uid
                let dataBase = Database.database().reference()
                //let code = self.getArtisanCode()
                var objDictionary = ["name": self.nameField.text!,
                                     "type": self.buttonSelected] as [String : Any]
                
                
                if self.buttonSelected == 1 {
                    // New Client User
                    let clientDB = dataBase.child("clients")
                    
                    clientDB.child(userID!).setValue(objDictionary) { (error, reference) in
                        if error != nil {
                            print(error!)
                        }else {
                            print("Client added successfully")
                        }
                    }
                    
                    self.performSegue(withIdentifier: "clientLoginSegue", sender: self)
                }
                else {
                    // New Artisan User
                    let artisanDB = dataBase.child("artisans")
                    
                    dataBase.child("artisanCode").observeSingleEvent(of: .value, with: { (snapshot) in
                        let code = snapshot.value as! Int
                        
                        // Assign Artisan unique code for clients
                        objDictionary["code"] = code
                        artisanDB.child(userID!).setValue(objDictionary)
                        
                        dataBase.child("artisanCode").setValue(code+1)
                    })
                    
                    self.performSegue(withIdentifier: "artisanHomeSegue2", sender: self)
                }
                
                // Hash unique UserID to type of account (client or artisan)
                let emailDB = dataBase.child("emails")
                emailDB.child(userID!).setValue(self.buttonSelected)
            }
        }
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

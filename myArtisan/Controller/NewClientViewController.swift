//
//  NewClientViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/3/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class NewClientViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var clients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        //var clients = [String]()
        let userID = Auth.auth().currentUser?.uid
        let clientDB = Database.database().reference().child("artisans").child(userID!).child("clients").childByAutoId()
    
        let newClient = ["name": name.text!,
                         "address": address.text!,
                         "phone": phone.text!]
        
        clientDB.setValue(newClient) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }else {
                print("Client Saved!")
            }
        }
        navigationController?.popViewController(animated: true)
        
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

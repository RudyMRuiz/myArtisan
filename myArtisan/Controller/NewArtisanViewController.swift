//
//  NewArtisanViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/4/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class NewArtisanViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var artisanCode: UITextField!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
    }
    
    // Sorry for the ugliness, I was limited on time
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let userID = Auth.auth().currentUser?.uid
        
        let artisanRef = ref.child("artisans")
        artisanRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                print(child)
                let x = child as! DataSnapshot
                print(x.key)
                let childDict = x.value as! [String:Any]
                let y = self.artisanCode.text!
                let z = childDict["code"] as! Int
                if y == String(z) {
                    // Match found, attaching client to Artisan!
                    print("YESSSSS")
                    let clientDB = self.ref.child("clients").child(userID!).child("artisans").childByAutoId()
                    let artisanDB = self.ref.child("artisans").child(x.key).child("clients").childByAutoId()
                    
                    let newClient = ["name": self.name.text!]
                    clientDB.setValue(newClient) {
                        (error, reference) in
                        
                        if error != nil {
                            print(error!)
                        }else {
                            print("Message Saved!!!")
                        }
                    }
                    self.ref.child("clients").child(userID!).observeSingleEvent(of: .value, with: { (snapshot2) in
                        let userName = snapshot2.value as! [String:Any]
                        artisanDB.setValue(["name": userName["name"]!])
                    })
                    
                    self.navigationController?.popViewController(animated: true)
                }else {
                    // Print Dialog of no match found
                    print("NOOOO")
                }
            }
        }
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

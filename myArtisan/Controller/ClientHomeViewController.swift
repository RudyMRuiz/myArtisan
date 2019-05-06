//
//  ClientHomeViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/2/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class ClientHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var menuShowing = false
    var artisanArray = [String]()
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var artisanTableView: UITableView!
    @IBOutlet weak var sideView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        artisanTableView.delegate = self
        artisanTableView.dataSource = self
        
        sideView.layer.shadowOpacity = 1
        sideView.layer.shadowRadius = 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
        getArtisanList()
    }
    
    // MARK: Buttons Configuration
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        
        if (menuShowing) {
            leadingConstraint.constant = -150
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch {
            print("error: unable to sign out")
        }
    }
    
    @IBAction func profilePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newArtisanSegue", sender: self)
    }
    
    func getArtisanList() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("clients").child(userID!).child("artisans")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? [String: Any] {

                for (key, value) in value{
                    let x = value as? [String: String]
                    
                    if !self.artisanArray.contains(x!["name"]!) {
                        self.artisanArray.append(x!["name"]!)
                        self.artisanTableView.reloadData()
                    }
                }
            }
        }
        //clientTableView.reloadData()
    }
    
    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artisanCell", for: indexPath)
        cell.textLabel?.text = artisanArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artisanArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        performSegue(withIdentifier: "artisanJobsSegue", sender: self)
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

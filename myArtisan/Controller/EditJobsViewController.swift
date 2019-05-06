//
//  EditJobsViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/6/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit
import Firebase

class EditJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var jobArray = [String]()
    @IBOutlet weak var jobTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        jobTableView.delegate = self
        jobTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getJobList()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let userID = Auth.auth().currentUser?.uid
        let jobRef = Database.database().reference().child("artisans").child(userID!).child("jobs").childByAutoId()
        var newJob : [String:String]?
        
        let alertController = UIAlertController(title: "New Job", message: "Enter the name of the new job", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Login"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in

            newJob = ["Job": (alertController.textFields?.first?.text)!]
            
            jobRef.setValue(newJob)
            self.getJobList()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getJobList() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("artisans").child(userID!).child("jobs")
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let autoIdSnap = child as! DataSnapshot
                let childDict = autoIdSnap.value as! [String: Any]
                print("THIS IS THE CHILD DICT: \(childDict)")
                let firstKey = childDict.keys.first! //the key to the first item
                let jobName = childDict[firstKey] as! String
                print(jobName)
                
                    
                if !self.jobArray.contains(jobName) {
                    self.jobArray.append(jobName)
                    self.jobTableView.reloadData()
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobCell", for: indexPath)
        cell.textLabel?.text = jobArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobArray.count
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

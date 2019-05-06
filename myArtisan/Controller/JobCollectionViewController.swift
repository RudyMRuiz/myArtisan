//
//  JobCollectionViewController.swift
//  myArtisan
//
//  Created by Rudy Ruiz on 12/6/18.
//  Copyright © 2018 Rudy Ruiz. All rights reserved.
//

import UIKit

class JobCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var jobCollection: UICollectionView!
    @IBOutlet weak var cellLabel: UICollectionViewCell!

    
//    var jobArray = [String]()
    let jobArray = ["Job 1", "Job 2", "Job 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        jobCollection.delegate = self
        jobCollection.dataSource = self
    }
    
    // MARK: Collection View functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jobCell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.jobArray[indexPath.item]
        
        // cell touch ups
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.backgroundColor = UIColor.red
        
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.backgroundColor = UIColor.cyan
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

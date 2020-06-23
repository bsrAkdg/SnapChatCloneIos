//
//  FeedVC.swift
//  SnapChatClone
//
//  Created by Büşra Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Busra Serdaroglu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var snapTableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap: Snap?
    var timeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        snapTableView.delegate = self
        snapTableView.dataSource = self
        getUserInfo()
        getSnaps()
    }
    
    func getSnaps() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapShot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapShot != nil && snapShot?.isEmpty == false {
                    self.snapArray.removeAll() // clear array
                    for document in snapShot!.documents {
                        
                        let documentId = document.documentID
                        
                        // create custom list
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            // delete
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                
                                            }
                                        }
                                        // TIMELEFT -> SNAPVC
                                        self.timeLeft = 24 - difference
                                    }
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                    
                                }
                            }
                        }
                    }
                    self.snapTableView.reloadData()
                }
            }
        }
    }
    
    func getUserInfo() {
        fireStoreDatabase.collection("UserInfo")
            .whereField("email", isEqualTo: Auth.auth().currentUser!.email!)
            .getDocuments { (snapshot, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error")
                } else {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents {
                            if let username = document.get("username") as? String {
                                UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                UserSingleton.sharedUserInfo.username = username
                                
                            }
                        }
                    }
                }
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        let snap = snapArray[indexPath.row]
        cell.username.text = snap.username
        cell.feedImage.sd_setImage(with: URL(string: snap.imageUrlArray[0]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = choosenSnap
            destinationVC.selectedTime = self.timeLeft
        }
    }
}

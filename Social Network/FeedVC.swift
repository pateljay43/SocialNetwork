//
//  FeedVC.swift
//  Social Network
//
//  Created by JAY PATEL on 6/2/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var logoutBtn: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]!
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var addImg: CircleImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = []
        logoutBtn.isUserInteractionEnabled = true
        logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped(_:))))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.shared.REF_POSTS.observe(DataEventType.value, with: postsUpdateHandler(_:))
    }
    
    func postsUpdateHandler(_ snapshot: DataSnapshot) -> Void {
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshot {
                if let dict = snap.value as? Dictionary<String, Any> {
                    let postKey = snap.key
                    self.posts.append(Post(postKey: postKey, postData: dict))
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostCell
        if cell == nil {
            cell = PostCell(style: .default, reuseIdentifier: "postCell")
        }
        cell!.configCell(posts[indexPath.row])
        return cell!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.image = image
        } else {
            print("Selected an invalid image")
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func logoutTapped(_ recognizer: UIGestureRecognizer) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Firebase signout error: \(error.localizedDescription)")
        }
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) {
            if let vc = self.presentingViewController , vc is LoginVC {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

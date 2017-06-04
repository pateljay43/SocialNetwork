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
    @IBOutlet weak var addImg: CircleImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var posts: [Post]!
    var imagePicker: UIImagePickerController!
    
    var ADD_IMG_BG: UIColor!
    var ADD_IMG: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = []
        logoutBtn.isUserInteractionEnabled = true
        logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutTapped(_:))))
        
        ADD_IMG = addImg.image
        ADD_IMG_BG = addImg.backgroundColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.shared.REF_POSTS.observe(DataEventType.value, with: postsUpdateHandler(_:))
    }
    
    func postsUpdateHandler(_ snapshot: DataSnapshot) -> Void {
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            posts = []
            for snap in snapshot {
                if let dict = snap.value as? Dictionary<String, Any> {
                    let postKey = snap.key
                    posts.append(Post(postKey: postKey, postData: dict))
                }
            }
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: POST_CELL, for: indexPath) as? PostCell
        if cell == nil {
            cell = PostCell(style: .default, reuseIdentifier: POST_CELL)
        }
        cell!.configCell(posts[indexPath.row])
        return cell!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.backgroundColor = UIColor.white
            addImg.image = image
        } else {
            resetPostView()
            print("Selected an invalid image")
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func addImageTapped(_ sender: UITapGestureRecognizer) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(_ sender: RoundButton) {
        guard let caption = captionField.text , caption != "" else {
            print("Require caption for creating new post")
            return
        }
        guard ADD_IMG_BG != addImg.backgroundColor , let image = addImg.image else {
            print("An image must be selected for creating new post")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, COMPRESSION) {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.shared.REF_POST_IMAGES.child("\(UUID().uuidString).jpg").putData(imageData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("Unable to upload the image to storage")
                } else {
                    if let metaData = metaData {
                        if let downloadURL = metaData.downloadURL() {
                            self.postToFirebase(imgUrl: downloadURL.absoluteString)
                            print("Uploaded image successfully")
                        }
                        self.resetPostView()
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
            CAPTION : captionField.text ?? "",
            IMAGE_URL : imgUrl,
            LIKES : 0
        ]
        let postIdRef = DataService.shared.REF_POSTS.childByAutoId()
        postIdRef.setValue(post)
    }
    
    func resetPostView() {
        captionField.text = ""
        addImg.backgroundColor = ADD_IMG_BG
        addImg.image = ADD_IMG
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

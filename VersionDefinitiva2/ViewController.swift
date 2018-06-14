//
//  ViewController.swift
//  VersionDefinitiva2
//
//  Created by CONRADO DELSO GONZALEZ on 14/6/18.
//  Copyright © 2018 CONRADO DELSO GONZALEZ. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import FirebaseStorage

class ViewController: UIViewController {
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    let ref = Database.database().reference()
    var imagePicker: UIImagePickerController
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            self.performSegue(withIdentifier: "toFeed", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeUserData(userId : String) {
        let downloadURL: String!
        
        if let imageData = UIImageJPEGRepresentation(selectedImage, 0.2) {
            
          let imgUid = NSUUID().uuidString
            
        let metaData = StorageMetadata()
            
        let uploadTask = storage.reference().putData(imageData, metadata: nil) { (metadata, error)
            in
            guard let metadata = metadata else {
                return
            }
            downloadURL = metadata.downloadURL
            self.ref.child("users").child(userId).setValue(
                "username": usernameField.text,
                "userImg": downloadURL
                ])
            
            }
        }
      
    }

    
        func signInpressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password)
            { (user, error)
                in
                if error != nil && !(self.usernameField.text?.isEmpty)! &&
                    self.userImgView.image != nil {
                    Auth.auth().createUser(withEmail: email, password:password)
                    { (user, error) in
                        self.storeUserData(userId: (user?.uid)!)
                        KeychainWrapper.standard.set(user?.uid)!, forKey:"uid")
                        self.performSegue(withIdentifier: "toFeed", sender: nil)
                    }
                    
                   
                } else {
                    if let userID = user?.uid {
                        KeychainWrapper.standard.set((userID), forKey:"uid")
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                }
            }    }
    }

}
}
}

extension ViewController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didFinishPickingMediaWithInfo info: [String : Any]) do {
            if let image = info[UIImagePickerController] as? UIImage {
                selectedImage = image
            }
            imagePicker.didmiss(animated: true, completion: nil)
        }
    
    
    
}

}









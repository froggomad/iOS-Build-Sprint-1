//
//  UserProfileVC.swift
//  Lunchly
//
//  Created by Kenny on 1/3/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cameraPickerButton: UIButton!
    
    //MARK: Class Properties
    var userController: UserController?
    var pickedImage: UIImage?
    var currentUser: User?
    weak var delegate: OnboardingUserProfileVC?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return saveUser()
    }
    
    //MARK: Helper Methods
    func setupView() {
        if userController == nil {
            print("userController is nil")
            let coreDataController = CoreDataController()
            userController = coreDataController.usersController
            userController?.createUsers()
        }
        
        textView.allowsEditingTextAttributes = false
        textView.textContainer.maximumNumberOfLines = 1
        textView.delegate = self
        if let currentUser = userController?.currentUser,
            currentUser.name != "Enter Your Name" {
                textView.isUserInteractionEnabled = false
                textView.text = currentUser.name
            } else {
                textView.text = "Enter Your Name"
                textView.textColor = .systemGray
        }
    }
    
    func saveUser() -> Bool {
        guard let userController = userController,
              let userNameText = textView.text,
              userNameText != "",
              userNameText != "Enter Your Name",
              let currentUser = userController.currentUser,
              let pickedData = self.pickedImage?.jpegData(compressionQuality: 1) ?? UIImage(systemName: "person.fill")?.jpegData(compressionQuality: 1)
        else {return false}
        print(userNameText)
        let mutatedUser = User(name: userNameText, image: pickedData, groups: [], restaurants: [])
        userController.updateUser(originalUser: currentUser, mutatedUser: mutatedUser)
        print(userController.users[0])
        textView.resignFirstResponder()
        return true
    }
    
}

extension UserProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == "\n" {
            textView.text = "Enter Your Name"
            textView.textColor = .systemGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return saveUser()
        }
        print(text)
        return true
    }
}

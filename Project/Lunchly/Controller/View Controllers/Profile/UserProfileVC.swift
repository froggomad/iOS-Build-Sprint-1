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
    var userSettingsController = UserSettingsController()
    weak var delegate: OnboardingUserProfileVC?
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CreateGroupSegue" {
            return saveUser()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddUserImageSegue" {
            guard let destination = segue.destination as? ChangeImageVC else {return}
            destination.userDelegate = self
            destination.user = userController?.currentUser
            destination.userController = userController
        }
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
        
        guard let currentUser = userController?.currentUser else {return}
        textView.text = currentUser.name
        if currentUser.name != "Enter Your Name" {
            textView.isUserInteractionEnabled = false
        } else {
            textView.isUserInteractionEnabled = true
            textView.becomeFirstResponder()
            textView.textColor = UIColor(named: "SecondaryAction")
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap)))
        imageView.image = UIImage(data: currentUser.image) ?? UIImage(systemName: "person.fill")
        roundImageView()
    }
    
    func roundImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
    }
    
    //MARK: Delegate Method Called From ChangeImageVC
    func updateUserImage(user: User) {
        self.imageView.image = UIImage(data: user.image)
        print("updating user from UserProfileVC")
    }
    
    @discardableResult func saveUser() -> Bool {
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

//MARK: TextView Delegate
extension UserProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .label
        if textView.text == "" || textView.text == "Enter Your Name" {
            textView.text = "Enter Your Name"
            textView.selectedRange = NSRange(location: 0, length: textView.text.count)
            textView.textColor = UIColor(named: "SecondaryAction")
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == "\n" || textView.text == "Enter Your Name" {
            textView.text = "Enter Your Name"
            textView.textColor = UIColor(named: "SecondaryAction")
        } else {
            textView.textColor = .label
            //if we're not in the onboarding view, we don't want the user to be able to edit their username
            if let skipsTutorial = userSettingsController.userSkipsTutorial,
                skipsTutorial != true {
                textView.isUserInteractionEnabled = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "Enter Your Name" {
            textView.text = ""
        }
        if text == "\n" {
            return saveUser()
        }
        print(text)
        return true
    }
    
    @objc func tap() {
        if !textView.isFirstResponder && (textView.text == "Enter Your Name" || textView.text == "" || textView.text == "\n" || !userSettingsController.userSkipsTutorial!) {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
}

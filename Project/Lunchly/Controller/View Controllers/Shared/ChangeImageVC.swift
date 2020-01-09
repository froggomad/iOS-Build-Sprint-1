//
//  changeGroupImageVC.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class ChangeImageVC: UIViewController, UINavigationControllerDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var userImageView: UIImageView! //Xcode won't allow me to connect to the same outlet for some reason, though I can with the others
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePickerButtonOutlet: UIButton!
    
    
    //MARK: IBActions
    @IBAction func imagePickerBtnTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Class Properties
    let imagePicker = UIImagePickerController()
    var groupController: GroupController?
    var userController: UserController?
    weak var groupDelegate: GroupDetailVC?
    weak var userDelegate: UserProfileVC?
    var group: Group?
    var user: User?
    
    
    //MARK: View Lifecycle (Update View)
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        updateViews()
    }
    
    //MARK: Helper Functions
    func updateViews() {
        imagePickerButtonOutlet.titlePadding(left: 8, right: 8, bottom: 8, top: 8)
        if let group = group {
            self.imageView.image = UIImage(data: group.imageData)
        } else if let user = user {
            self.userImageView.image = UIImage(data: user.image) ?? UIImage(systemName: "person.fill")
        }
    }
}

//MARK: ImagePickerDelegate
extension ChangeImageVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //update the view
            if group != nil {
                imageView.contentMode = .scaleAspectFit
                imageView.image = pickedImage
            } else if user != nil {
                userImageView.contentMode = .scaleAspectFit
                userImageView.image = pickedImage
            }
            let pickedImageData = pickedImage.jpegData(compressionQuality: 1.0) ?? Data()
            //update the group
            if var group = group {
                groupController?.updateImageData(group: group, imageData: pickedImageData) //the original group needs to go here for comparison in the group controller
                group.imageData = pickedImageData //it's now safe to mutate the group instance we just unwrapped
                groupDelegate?.updateGroup(group: group) //finally the delegate gets the updated group
            } else if let user = user { //update the User
                let mutatedUser = User(name: user.name, image: pickedImageData, groups: user.groups, restaurants: user.restaurants) //pardon my shortcut
                userController?.updateUser(originalUser: user, mutatedUser: mutatedUser)
                userDelegate?.updateUserImage(user: mutatedUser)
            }
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

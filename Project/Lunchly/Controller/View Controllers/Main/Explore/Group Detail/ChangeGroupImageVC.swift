//
//  changeGroupImageVC.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class ChangeGroupImageVC: UIViewController, UINavigationControllerDelegate {
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    weak var delegate: GroupDetailVC?
    var group: Group? {
        didSet {
            
        }
    }
    
    //MARK: View Lifecycle (Update View)
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        updateViews()
    }
    
    //MARK: Helper Functions
    func updateViews() {
        self.imageView.image = UIImage(data: group?.imageData ?? Data())
    }

}

//MARK: ImagePickerDelegate
extension ChangeGroupImageVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //update the view
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            let pickedImageData = pickedImage.jpegData(compressionQuality: 1.0) ?? Data()
            //update the group
            guard var group = group else {return}
            groupController?.updateImageData(group: group, imageData: pickedImageData) //the original group needs to go here for comparison in the group controller
            group.imageData = pickedImageData //it's now safe to mutate the group instance we just unwrapped
            delegate?.updateGroup(group: group) //finally the delegate gets the updated group
        }
        imagePicker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}


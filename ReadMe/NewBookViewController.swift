//
//  NewBookViewController.swift
//  ReadMe
//
//  Created by Andrii Nepodymka on 7/28/21.
//

import UIKit

class NewBookViewController: UITableViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var authorTextField: UITextField!
    @IBOutlet var bookImageView: UIImageView!
    
    @IBAction func updateImage() {
    
    let imagePicker = UIImagePickerController()
    
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.layer.cornerRadius = 16
    }
}










extension NewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        bookImageView.image = selectedImage
        
        dismiss(animated: true)
    }
    
}

extension NewBookViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorTextField.becomeFirstResponder()
        } else {
            return textField.resignFirstResponder()
        }
    }
    
}

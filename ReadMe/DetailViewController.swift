//
//  DetailViewController.swift
//  ReadMe
//
//  Created by Andrii Nepodymka on 7/27/21.
//

import UIKit


class DetailViewController: UITableViewController {
    
    let book: Book
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var reviewTextView: UITextView!
    
    
    @IBAction func updateImage() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = book.image
        imageView.layer.cornerRadius = 16
        
        if let review = book.review {
            reviewTextView.text = review
            
        }
        
        titleLabel.text = book.title
        authorLabel.text = book.author
        reviewTextView.addDonButton()
    }
    
    required init?(coder: NSCoder) { fatalError("This never be called") }
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
        
        
    }
    
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true)
    }
    
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}




extension UITextView {
    
    func addDonButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpaace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpaace, doneButton]
        self.inputAccessoryView = toolbar

    }
    
}

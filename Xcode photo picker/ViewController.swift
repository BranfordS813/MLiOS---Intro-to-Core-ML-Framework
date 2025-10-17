//
//  ViewController.swift
//  Xcode photo picker
//
//  Created by brandonsanford on 10/14/25.
// // changes test ?

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: BOutlets
    // This is the IBOutlet that connects the label to your code
    @IBOutlet weak var MultiLineLabel1: UILabel!
    // Lets create a nother IBOutlet that connects a second label to code
    @IBOutlet weak var MultiLineLabel2: UILabel!
    // Tap Button to select Photo
    @IBOutlet weak var btn: UIButton!
    // Show selected Photos
    @IBOutlet weak var UI_Image_View: UIImageView!
    // Action - Button tapped --> Select Photo
    
    
//    // Previous Attempt:
//    // Impliment two delegate methods: imagePickerController and imagePickerControllerDidCancel. the first method is called when the user is finished selecting an image from the library. The second is called if the user decides to cancel the image picker.
//
//    func imagePickerController(_picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController. InfoKey : Any]){
//        
//        let pickedImage = info[UIImagePIckerController.InfoKey.
//        originalImage] as! UIImage
//        
//        imageView.image = pickedImage
//        picker.dismiss(animated: true)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Set the number of lines to 0 (already done in Storyboard, but good to confirm)
        MultiLineLabel1.numberOfLines = 0
        
        // 2. Set the multi-line string using '\n' for line breaks
        MultiLineLabel2.numberOfLines = 0
        MultiLineLabel2.text = "App Developed by: \nBrandon Sanford\n\nThis is a test of a multi-line label. Example of third line entry with \\n"
    }
    
    // MARK: - IBActions (Event Handlers)
    
    @IBAction func pickImageBtnClick(_ sender: Any) {
        // For the user to select a photo form the photo library, we have to conform with the UIImagePickerControllerDelegate protocol as well as the UINavigationControllerDelegate protocol.
        
        let imagePicker = UIImagePickerController()
        // The delegate must be set to 'self' (this View Controller)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerController Delegate Methods (Gemini)
        
        // 1. Method called when user finishes picking an image
        // Note the correction in the method signature (removed the underscore and fixed the InfoKey lookup)
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
             
            // 2. Correctly use the InfoKey enumeration for the original image
            guard let pickedImage = info[.originalImage] as? UIImage else {
                // Use guard to safely unwrap the image, otherwise dismiss
                picker.dismiss(animated: true)
                return
            }
             
            // 3. Assign the picked image to the UIImageView
            // NOTE: I'm assuming you intended to use UI_Image_View, but the book may have a typo.
            // I've used UI_Image_View here, but you should check if the book uses 'imageView'.
            UI_Image_View.image = pickedImage
            
            // 4. Dismiss the picker
            picker.dismiss(animated: true)
        }
         
        // 5. Method called when user cancels the picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

}


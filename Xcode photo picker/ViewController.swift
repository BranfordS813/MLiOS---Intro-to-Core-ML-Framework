//
//  ViewController.swift
//  Xcode photo picker
//
//  Created by brandonsanford on 10/14/25.
// // changes test ?

import UIKit

// import CoreML Model
import CoreML

// import CoreVideo (for image resizing)
import CoreVideo

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: IBOutlets
    // This is the IBOutlet that connects the label to your code
    @IBOutlet weak var MultiLineLabel1: UILabel!
    // Lets create a nother IBOutlet that connects a second label to code
    @IBOutlet weak var MultiLineLabel2: UILabel!
    // Tap Button to select Photo
    @IBOutlet weak var btn: UIButton!
    // Show selected Photos
    @IBOutlet weak var UI_Image_View: UIImageView!
    // Action - Button tapped --> Select Photo
    
    // Classifer UILabel
    @IBOutlet weak var classifier: UILabel!
    
    
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
    
//    // MARK: - Declare model variable for Core ML model
//    
//    var model: MobileNetV2
////
//    // MARK: - Override viewWillAppear() method (older verison?)
//    override func viewWillAppear(_ animated: Bool){
//        model = MobileNetV2()
//    }
////
    // MARK: - Apply Lazy Initialization for Core ML model
    // MARK: - Declare model variable for Core ML model
    // Use 'lazy var' for proper initialization
    lazy var model: MobileNetV2 = {
        do {
            // Use the common initializer for Core ML models, which often throws an error.
            // Assuming MobileNetV2 is the name of your Core ML model class.
            return try MobileNetV2(configuration: MLModelConfiguration())
        } catch {
            // If the model fails to load, the app can't run the ML part, so it's a fatal error.
            fatalError("Failed to load MobileNetV2 model: \(error)")
        }
    }()

    // MARK: - Override viewWillAppear() method (Remove the model assignment)
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated) // Always call super for life-cycle methods
        // model = MobileNetV2() <-- REMOVE THIS LINE
    }
    
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
            
            // MARK: - For Core ML model, resize image to 224x 224 pixels
            
            // Resize image to 224 x 224 pixels
            UIGraphicsBeginImageContextWithOptions (CGSize(width: 224, height: 224), true, 2.0)
            
            pickedImage.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            
            UIGraphicsEndImageContext()
           
            // Store the new image in the form of a pixel buffer
           let attrs = [kCVPixelBufferCGImageCompatibilityKey:
           kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey:
           kCFBooleanTrue] as CFDictionary
            
            var pixelBuffer : CVPixelBuffer?
            
            let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
            
            guard (status == kCVReturnSuccess) else {
                return
                }
            
            // Convert all the pixels in image into device dependent RGB color space
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            
            // Store pixel data in CGCContext - helps modify properties of image's pixels
            let context = CGContext(data: pixelData, width:Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            // Scale the image
            context?.translateBy(x: 0, y: newImage.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            // Update final image buffer
            UIGraphicsPushContext(context!)
            
            newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
            
            UIGraphicsPopContext()
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
            // MARK: - Predict Image Delgate Method for Core ML
            
            guard let prediction = try? model.prediction(image: pixelBuffer!) else {
                classifier.text = "Can't Predict!"
                return
            }
            classifier.text = "This is probably \(prediction.classLabel)."
            
        }
         
        // 5. Method called when user cancels the picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

}


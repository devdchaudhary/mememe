//
//  ViewController.swift
//  MemeMe
//
//  Created by Devanshu on 06/03/18.
//  Copyright © 2018 Devanshu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    // Image Picker is a global variable
    
    var cameraandalbumimagepicker = UIImagePickerController()
    
    // Top Toolbar + Share Button
    
    @IBOutlet weak var topbar: UIToolbar!
    @IBOutlet weak var Toptextfield: UITextField!
    @IBOutlet weak var Sharebutton: UIBarButtonItem!

    //Bottom Toolbar
    
    @IBOutlet weak var bottombar: UIToolbar!
    @IBOutlet weak var Bottomtextfield: UITextField!

    // Main Function that displays the view
    
    @IBOutlet weak var MemeView: UIImageView!
    
    override func viewDidLoad() {

    setTextAttribute(textField: Toptextfield, str: "TOP")
    setTextAttribute(textField: Bottomtextfield, str: "BOTTOM")
        
    MemeView.backgroundColor = UIColor.black
        
    view.backgroundColor = UIColor.black
    
    super.viewDidLoad()
        
    }
    
    //Hiding the status Bar
    
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    // ViewVillAppear and ViewwillDisappear function necessary for defining whether the keyboard will show up or not, also the share button is hidden until a meme is generated
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
        Sharebutton.isEnabled = MemeView.image != nil
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()

        
    }
    
    // Image generation methods
    
    // Function for choosing image from the camera
    
    func launchCamera() {
        
        // Defining the alert that shows up if the device does not have a camera
        
        let nocameraalert = UIAlertController(title: "ERROR", message: "CAMERA NOT FOUND", preferredStyle: .alert)
        
        nocameraalert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        
        // Condition for the alert
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            
            cameraandalbumimagepicker.delegate = self
            cameraandalbumimagepicker.sourceType = .camera
            cameraandalbumimagepicker.allowsEditing = true
            self.present(cameraandalbumimagepicker, animated: true, completion: nil)
            
        } else {
            
            self.present(nocameraalert, animated: true, completion: nil)
            
        }
    }
    
    // Function for choosing image from the album
    
    func launchAlbum() {
        
        cameraandalbumimagepicker.delegate = self
        cameraandalbumimagepicker.allowsEditing = true
        cameraandalbumimagepicker.allowsEditing = true
        cameraandalbumimagepicker.sourceType = .photoLibrary
        self.present(cameraandalbumimagepicker, animated: true, completion: nil)
        
    }
    
    // Function that tells the imageview to show the picked image by the user
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedimage = info[UIImagePickerControllerOriginalImage] as! UIImage
        MemeView.image = pickedimage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Function for the Choosing the image alert
    
    @IBAction func ChooseImage(_ sender: UIButton) {
        
        let cameraandalbumalert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Take Photo option shown to the user in the alert view launched
        
        cameraandalbumalert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in self.launchCamera()
            
        }))
        
        // Launch album option shown when alert view launched
        
        cameraandalbumalert.addAction(UIAlertAction(title: "Launch Album", style: .default, handler: { _ in self.launchAlbum()
            
        }))
        
        cameraandalbumalert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = cameraandalbumalert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            
            popoverController.permittedArrowDirections = []
        }
        
        self.present(cameraandalbumalert, animated: true, completion: nil)
        
    }
    
    // All Keyboard and Text Generation Methods
    
    // Text fields outline attribute
    
    let textattributes = [
        
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "Impact", size: 50)!,
        NSAttributedStringKey.strokeWidth.rawValue : NSNumber(value: -4.0)
        
        ] as [String: Any]
    
    func setTextAttribute(textField : UITextField, str : String) {
        textField.delegate = self
        textField.text = str
        textField.defaultTextAttributes = textattributes
        textField.textAlignment = .center
    }
    
    // Function for activating the return button on the keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    // Function for sending the notification for enabling the keyboard

    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Function for moving the frame up is keyboard is called
    
   @objc func keyboardWillShow(notification: NSNotification) {
        
        if Bottomtextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    // Function for determining the keyboard height and sending that as a notification to KeyboardWillShow function
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardsize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardsize.cgRectValue.height
        
    }
    
    // Function for sending the notification for disabling the keyboard
    
    func unsubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    // Function for hiding the keyboard once it's done getting used
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
        
    }

    // Saving the meme
    
    func save() {
        
        // Creating the meme

        let meme = Meme(topText: Toptextfield.text!, bottomText: Bottomtextfield.text!, originalImage: MemeView.image!, memeImage: generateMemedImage())
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)

    }
    
    //Saving the generated memed image and passing it as a UIImage
    
    func generateMemedImage() -> UIImage {
        
        topbar.isHidden = true
        
        bottombar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        topbar.isHidden = false
        
        bottombar.isHidden = false
        
        return memedImage
    }
    
    // Sharing Method
    
    @IBAction func sharememe(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.completionWithItemsHandler = {activity, completed, items, error in
            
            if completed {
                
                self.save()
                
                self.Sharebutton.isEnabled = true
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Cancel Action
    
    @IBAction func cancelAction(sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Func to cancel selection
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
}


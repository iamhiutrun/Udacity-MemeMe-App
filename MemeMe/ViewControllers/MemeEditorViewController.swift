//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Trung Hieu Luong on 14/07/2022.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var pickAlbumButton: UIButton!
    
    @IBOutlet weak var pickCameraButton: UIButton!
    
    @IBOutlet weak var navBar: UINavigationBar!

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    enum TextFieldInit: String {
            case top = "TOP", bottom = "BOTTOM"
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = TextFieldInit.top.rawValue
        bottomTextField.text = TextFieldInit.bottom.rawValue
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickCameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()

        configureTextFields(textField: topTextField)
        configureTextFields(textField: bottomTextField)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscibeFromKeyboardNotifications()
    }
    
    //MARK: Generate and save meme
    func generateMemedImage() -> UIImage {
        toolBarVisible(visible: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBarVisible(visible: true)
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originImage: imagePickerView.image!, memedImage: memedImage)
        
        let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           appDelegate.memes.append(meme)
    }
    
    //MARK: Image Pickers
    
    func configurePickAnImage(_ sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
        shareButton.isEnabled = true
    }

    @IBAction func pickerButton(_ sender: UIButton) {
        pickCameraButton.tag = 1

        pickAlbumButton.tag = 2
        
        switch sender.tag {
        case 1:
            configurePickAnImage(.camera)
        case 2:
            configurePickAnImage(.photoLibrary)
        default:
            print("default")
        }
    }
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                  imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
            dismiss(animated: true, completion: nil)
              }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder == true {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
       }
    
    func unsubscibeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification , object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    //MARK: Buttons
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
    cancelButton.isEnabled = true
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save(memedImage: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Text Fields
    
    func configureTextFields(textField: UITextField) {
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        superview?.addSubview(textField)
        textField.superview?.bringSubviewToFront()
        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == TextFieldInit.top.rawValue || textField.text == TextFieldInit.bottom.rawValue {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func toolBarVisible(visible: Bool){
           toolbar.isHidden = !visible
           navBar.isHidden = !visible
       }
    }


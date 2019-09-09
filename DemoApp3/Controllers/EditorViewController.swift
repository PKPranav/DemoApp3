//
//  EditorViewController.swift
//  DemoApp3
//
//  Created by Pramod Kumar Pranav on 09/09/19.
//  Copyright © 2019 Pramod Kumar Pranav. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    @IBOutlet weak  var txtView:UITextView!
    var selectedText: String?
    var imagePicker: ImagePicker!
    
    private struct Style {
        static let navTitle = "Word Pad"
        static let alertTitle = "Choose Options"
        static let addImage = "Add Image"
        static let normal = "Normal selected text"
        static let bold = "Bold selected text"
        static let italic = "Italic selected text"
        static let cancel = "Cancel"
        static let increaseFont = "Font Size(+)"
        static let decreaseFont = "Font Size(-)"
    }
    
    private enum FontType {
        case normal
        case bold
        case italic
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }
    
    //MARK: - Setup
    
    /// To setup UI
    func setUp() {
        self.navigationItem.title = Style.navTitle
        txtView.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTextViewClick))
        self.navigationItem.rightBarButtonItem = editBarButton
        
        txtView.becomeFirstResponder()
    }
    
    
    //MARK: - Keyboard method
    
    /// To update textview size by keyboard height
    ///
    /// - Parameter keyboardHeight: keyboard height
    func updateTextViewSize(forKeyboardHeight keyboardHeight: CGFloat) {
        txtView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let rectValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardSize = rectValue.cgRectValue.size
            updateTextViewSize(forKeyboardHeight: keyboardSize.height)
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        updateTextViewSize(forKeyboardHeight: 0)
    }
    
    
    //MARK: - Action Method
    @objc func editTextViewClick(_ sender: Any) {
        txtView.resignFirstResponder()
        actionSheet(sender)
    }
    
    
    //MARK: - Helper Method
    
    ///create and NSTextAttachment and add your image to it.
    func addImage(_ image:UIImage) {
        
        var attributedString :NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString:txtView.attributedText)
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        
        let oldWidth = textAttachment.image!.size.width;
        
        //I'm subtracting 10px to make the image display nicely, accounting
        //for the padding inside the textView
        
        let scaleFactor = oldWidth / (txtView.frame.size.width - 10);
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attrStringWithImage)
        txtView.attributedText = attributedString;
    }
    
    
    /// To update selected text
    ///
    /// - Parameter fontType: font type like bold, italic
    private func updateSelectedText(_ fontType:FontType) {
        let main_string = txtView.text
        let string_to_updte = self.selectedText ?? ""
        
        let range = (main_string! as NSString).range(of: string_to_updte)
        
       // let attribute = NSMutableAttributedString.init(string: main_string ?? "")
        var attribute :NSMutableAttributedString!
        attribute = NSMutableAttributedString(attributedString:txtView.attributedText)
        switch fontType {
            
        case .bold:
            attribute.addAttribute(NSAttributedString.Key.font, value: txtView.font?.bold as Any , range: range)
        case .italic:
            attribute.addAttribute(NSAttributedString.Key.font, value: txtView.font?.italic as Any , range: range)
        case .normal:
            attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: txtView.font!.pointSize) , range: range)
            
        }
        txtView.attributedText = attribute
    }
    
    
    /// To open action sheet
    ///
    /// - Parameter sender: sender
    func actionSheet(_ sender:Any) {
        let alert = UIAlertController(title: Style.alertTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Style.bold, style: .default, handler: { [weak self] _ in
            self?.updateSelectedText(.bold)
        }))
        
        alert.addAction(UIAlertAction(title: Style.italic, style: .default, handler: { [weak self] _ in
            self?.updateSelectedText(.italic)
        }))
        
        alert.addAction(UIAlertAction(title: Style.normal, style: .default, handler: { [weak self]  _ in
            self?.updateSelectedText(.normal)
        }))
        
        alert.addAction(UIAlertAction(title: Style.increaseFont, style: .default, handler: { [weak self]  _ in
            self?.increaseFontSize()
        }))
        
        alert.addAction(UIAlertAction(title: Style.decreaseFont, style: .default, handler: { [weak self]  _ in
            self?.decreaseFontSize()
        }))
        
        alert.addAction(UIAlertAction(title: Style.addImage, style: .default, handler: { [weak self] _ in
            if let sSelf = self {
                sSelf.imagePicker.present(from: sSelf.view)
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: Style.cancel, style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// To increase font size of text view
    func increaseFontSize() {
        txtView.increaseFontSize()
    }
    
    /// To decrease font size of text view
    func decreaseFontSize() {
        txtView.decreaseFontSize()
    }
    
}


// MARK: - ImagePickerDelegate
extension EditorViewController: ImagePickerDelegate {
    
    /// To add selected image from picker
    ///
    /// - Parameter image: choosed image
    func didSelect(image: UIImage?) {
        if let image = image {
            addImage(image)
        }
    }
}

// MARK: - UITextViewDelegate
extension EditorViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if let textRange = textView.selectedTextRange {
            let selectedText = textView.text(in: textRange)
            self.selectedText = selectedText
        }
    }
}

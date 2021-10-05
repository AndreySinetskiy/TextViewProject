//
//  ViewController.swift
//  TextViewProject
//
//  Created by 1 on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!{
        didSet {
            textView.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = ""
        textView.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 20)
        textView.backgroundColor = .white
        
        stepper.layer.cornerRadius = 6
        stepper.value = 20
        stepper.minimumValue = 10
        stepper.maximumValue = 30
        
        stepper.tintColor = .white
        stepper.backgroundColor = .blue
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    
    @objc func updateTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardDidHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyBoardFrame.height - textViewConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
    }
  
    @IBAction func changeTextSize(_ sender: UIStepper) {
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        textView.font = UIFont(name: font ?? "", size: fontSize)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        //view.endEditing(true) to all objects
        textView.resignFirstResponder()
    }
}
// MARK: - extension

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = view.backgroundColor
        textView.textColor = .black
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        
        return textView.text.count + (text.count - range.length) <= 60
    }
}

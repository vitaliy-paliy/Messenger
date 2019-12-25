//
//  Helpers.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

// Caches the images
let imgCache = NSCache<NSString, UIImage>()

class ContactsAnimationButton: UIButton{
    var cell: ContactsCell?
    var cellFrame: CGRect?
    var friendInfo: FriendInfo?
}

class RefreshIndicator: UIActivityIndicatorView {
    var order: Bool!
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupButton(_ button: UIButton, _ title: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = Constants.Colors.appColor
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
    }
    
    func setupTextField(_ textField: UITextField, _ placeholder: String, _ leftView: UIView){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.leftView = leftView
        textField.textColor = .black
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor(displayP3Red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        textField.layer.cornerRadius = 16
        textField.borderStyle = .none
    }
    
    func setupImages(_ image: UIImageView, _ contentMode: UIImageView.ContentMode, _ cornerRadius: CGFloat, _ masksToBounds: Bool){
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = contentMode
        image.layer.cornerRadius = cornerRadius
        image.layer.masksToBounds = masksToBounds
    }
    
    func configureTextFieldConstraints(_ tf: UITextField, _ topEqualTo: UIView, _ topConst: CGFloat) -> [NSLayoutConstraint]{
        return [
            tf.topAnchor.constraint(equalTo: topEqualTo.topAnchor, constant: topConst),
            tf.heightAnchor.constraint(equalToConstant: 35),
            tf.widthAnchor.constraint(equalToConstant: 200),
            tf.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
    }
    
    func configureButtonsConstraints(_ button: UIButton, _ topEqualTo: UIView, _ topConst: CGFloat, _ height: CGFloat, _ width: CGFloat, _ centerConst: CGFloat = 0) -> [NSLayoutConstraint]{
        return [
            button.heightAnchor.constraint(equalToConstant: height),
            button.widthAnchor.constraint(equalToConstant: width),
            button.topAnchor.constraint(equalTo: topEqualTo.topAnchor, constant: topConst),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: centerConst),
        ]
    }
    
    func configureImagesConstraints(_ image: UIImageView, _ height: CGFloat, _ width: CGFloat, _ topView: UIView ,  _ topConst: CGFloat) -> [NSLayoutConstraint]{
        return [
            image.heightAnchor.constraint(equalToConstant: height),
            image.widthAnchor.constraint(equalToConstant: width),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: topView.topAnchor, constant: topConst)
        ]
    }
    
    func configureLabels(_ label: UILabel, _ text: String,  color: UIColor, size: CGFloat){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: size)
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = color
    }
    
    func configureLabelConstraints(view: UIView, label: UILabel, topEqualTo: UIView, topConst: CGFloat) -> [NSLayoutConstraint]{
        return [
            label.topAnchor.constraint(equalTo: topEqualTo.bottomAnchor, constant: topConst),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 25)
        ]
    }
    
    func calculateFrameInText(message: String) -> CGRect{
        return NSString(string: message).boundingRect(with: CGSize(width: 200, height: 9999999), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica Neue", size: 16)!], context: nil)
    }
    
    func hideKeyboardOnTap(_ cView: UICollectionView? = nil){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        if let cView = cView {
            cView.addGestureRecognizer(tap)
        }
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
     
    // NETWORKING
    
    func getFriendData(friend: FriendInfo, dict: String? = nil, values: [String: Any]){
        friend.id = dict
        friend.email = values["email"] as? String
        friend.profileImage = values["profileImage"] as? String
        friend.name = values["name"] as? String
        friend.isOnline = values["isOnline"] as? Bool
        friend.lastLogin = values["lastLogin"] as? NSNumber
    }
    
    func setupUserMessage(for values: [String:Any]) -> Messages{
        let message = Messages()
        message.sender = values["sender"] as? String
        message.recipient = values["recipient"] as? String
        message.message = values["message"] as? String
        message.time = values["time"] as? NSNumber
        message.mediaUrl = values["mediaUrl"] as? String
        message.imageWidth = values["width"] as? NSNumber
        message.imageHeight = values["height"] as? NSNumber
        message.id = values["messageId"] as? String
        return message
    }
    
}

extension UIImageView {
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .black
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        return activityIndicator
    }
    
    func loadImage(url: String){
        self.image = nil
        if let img = imgCache.object(forKey: url as NSString) {
            self.image = img
            return
        }
        isUserInteractionEnabled = false
        backgroundColor = .lightGray
        let indicator = activityIndicator
        DispatchQueue.main.async {
            indicator.startAnimating()
        }
        let imgUrl = URL(string: url)
        if imgUrl == nil {
            return
        }
        let task = URLSession.shared.dataTask(with: imgUrl!) { (data, response, error) in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data){
                    self.backgroundColor = .clear
                    self.isUserInteractionEnabled = true
                    indicator.stopAnimating()
                    self.alpha = 1
                    imgCache.setObject(image, forKey: url as NSString)
                    self.image = image
                }
            }
        }
        task.resume()
    }
}

extension UITextView {
    
    func calculateLines() -> Int {
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var index = 0, numberOfLines = 0
        var lineRange = NSRange(location: NSNotFound, length: 0)
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
            if text.last == "\n" {
                numberOfLines += 1
            }
        }
        return numberOfLines
    }
}


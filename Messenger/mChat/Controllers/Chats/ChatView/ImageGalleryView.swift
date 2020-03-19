//
//  ImageGalleryView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SelectedImageView: UIView, UINavigationControllerDelegate{
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var keyWindow = UIApplication.shared.windows[0]
    var chatVC: ChatVC?
    var sharedMediaVC: SharedMediaVC?
    var cellImage: UIImageView!
    var cellFrame: CGRect!
    var message: Messages?
    let imageView = UIImageView()
    let exitButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ cellImage: UIImageView, _ message: Messages?, _ chatVC: ChatVC? = nil, _ sharedMediaVC: SharedMediaVC? = nil) {
        super.init(frame: .zero)
        self.cellImage = cellImage
        self.chatVC = chatVC
        self.sharedMediaVC = sharedMediaVC
        self.cellImage.isHidden = true
        self.message = message
        cellFrame = cellImage.superview?.convert(cellImage.frame, to: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUI() {
        setupView()
        setupSelectedImage()
        setupExitButton()
        setupSaveButton()
        setupUserInfo()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupView() {
        if let chatVC = chatVC {
            frame = chatVC.view.frame
        }else{
            frame = sharedMediaVC!.view.frame
        }
        keyWindow.addSubview(self)
        backgroundColor = .black
        setupGestures()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupExitButton() {
        addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        exitButton.tintColor = .white
        exitButton.addTarget(self, action: #selector(handleSwipe), for: .touchUpInside)
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 8),
            exitButton.topAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.topAnchor, constant: 8),
            exitButton.widthAnchor.constraint(equalToConstant: 40),
            exitButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSaveButton() {
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -8),
            saveButton.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            saveButton.widthAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupGestures(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        addGestureRecognizer(swipeUp)
        addGestureRecognizer(swipeDown)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSelectedImage() {
        addSubview(imageView)
        imageView.frame = cellFrame
        imageView.image = cellImage.image
        // Animate image to the center
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let height = self.imageView.frame.height / self.imageView.frame.width * self.keyWindow.frame.width
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.keyWindow.frame.width, height: height)
            self.imageView.center = self.keyWindow.center
        })
        
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func handleSwipe() {
        removeFromSuperview()
        if let chatVC = chatVC {
            chatVC.view.addSubview(imageView)
        }else{
            sharedMediaVC!.view.addSubview(imageView)
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageView.frame = self.cellFrame
            self.imageView.layer.cornerRadius = self.cellImage.layer.cornerRadius
            self.imageView.layer.masksToBounds = true
        }) { (true) in
            self.imageView.removeFromSuperview()
            self.cellImage.isHidden = false
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupUserInfo() {
        guard let message = message else { return }
        guard let friend = chatVC != nil ? chatVC!.friend : sharedMediaVC!.friend else { return }
        let userName = UILabel()
        addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.text = message.sender == CurrentUser.uid ? CurrentUser.name : friend.name
        userName.textColor = .white
        userName.font = UIFont.boldSystemFont(ofSize: 16)
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 16),
            userName.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
        setupDate()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupDate() {
        let dateLabel = UILabel()
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = Calendar(identifier: .gregorian).calculateTimePassed(date: NSDate(timeIntervalSince1970: message?.time.doubleValue ?? 0))
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    @objc private func saveImage() {
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageHandler(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func imageHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        }else{
            if chatVC != nil {
                chatVC?.showAlert(title: "Success", message: "This image was successfully saved to your photo library")
            }else{
                sharedMediaVC?.showAlert(title: "Success", message: "This image was successfully saved to your photo library")
            }
        }
    }
        
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

}

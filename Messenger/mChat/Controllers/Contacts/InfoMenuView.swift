//
//  InfoMenuAnimationView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/17/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit

class InfoMenuView: UIView {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // InfoMenuView. When a user clicks on a cell in ContactsVC, this view will animate to the middle of a screen.
    
    var cell: ContactsCell!
    var cellFrame: CGRect!
    var friend: FriendInfo!
    var contactsVC: ContactsVC!
    let infoImage = UIImageView()
    let infoName = UILabel()
    let infoEmail = UILabel()
    let blurView = UIVisualEffectView()
    let stackView = UIStackView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(cell: ContactsCell, cellFrame: CGRect, friend: FriendInfo, contactsVC: ContactsVC) {
        super.init(frame: .zero)
        self.cell = cell
        self.cellFrame = cellFrame
        self.friend = friend
        self.contactsVC = contactsVC
        setupInfoMenuView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func setupInfoMenuView() {
        setupInfoBlur()
        let window = UIApplication.shared.windows[0]
        window.addSubview(self)
        frame = cellFrame
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        setupInfoImage()
        setupInfoName()
        setuoInfoEmail()
        setupStackView()
        startingAnimationInfoMenu()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: START ANIM METHOD
    
    func startingAnimationInfoMenu(){
        blurView.layer.add(blurEffectAnim(), forKey: "ExpandBlurView")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.frame = CGRect(x: 40, y: self.contactsVC.view.center.y / 2, width: self.cellFrame.width - 80, height: self.cellFrame.height + 200)
            self.infoImage.layer.add(self.moveObjectToCenter(xValue: 10, yValue: 0, yConst: 80), forKey: "MoveImageToTheCenter")
            self.infoName.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 80, yConst: 130), forKey: "MoveNameToTheCenter")
            self.infoEmail.layer.add(self.moveObjectToCenter(xValue: 60, yValue: 130, yConst: 160), forKey: "MoveEmailToTheCenter")
        }) { (true) in
            self.stackView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.stackView.transform = .identity
                for subview in 0..<self.stackView.arrangedSubviews.count {
                    self.stackView.arrangedSubviews[subview].transform = .identity
                }
                self.stackView.alpha = 1
            })
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoImage() {
        addSubview(infoImage)
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.loadImage(url: friend.profileImage ?? "")
        infoImage.layer.cornerRadius = 30
        infoImage.layer.masksToBounds = true
        infoImage.contentMode = .scaleAspectFill
        let constraints = [
            infoImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            infoImage.widthAnchor.constraint(equalToConstant: 60),
            infoImage.heightAnchor.constraint(equalToConstant: 60),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoName() {
        addSubview(infoName)
        infoName.translatesAutoresizingMaskIntoConstraints = false
        infoName.textAlignment = .center
        infoName.text = friend.name
        infoName.textColor = .black
        infoName.font = UIFont(name: "Helvetica Neue", size: 24)
        let constraints = [
            infoName.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoName.leadingAnchor.constraint(equalTo: infoImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setuoInfoEmail() {
        addSubview(infoEmail)
        infoEmail.translatesAutoresizingMaskIntoConstraints = false
        infoEmail.text = friend.email
        infoEmail.textAlignment = .center
        infoEmail.textColor = .gray
        infoEmail.font = UIFont(name: "Helvetica Neue", size: 16)
        let constraints = [
            infoEmail.topAnchor.constraint(equalTo: infoName.bottomAnchor),
            infoEmail.leadingAnchor.constraint(equalTo: infoImage.trailingAnchor, constant: 15)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func moveObjectToCenter(xValue: CGFloat, yValue: CGFloat, yConst: CGFloat) -> CAKeyframeAnimation {
        let movingImageAnimation = CAKeyframeAnimation(keyPath: "position")
        let viewCenterConst = center.x - 40
        let path = UIBezierPath()
        path.move(to: CGPoint(x: xValue, y: yValue))
        path.addQuadCurve(to: CGPoint(x: viewCenterConst, y: yConst), controlPoint: CGPoint(x: frame.width * 1/3, y: 120))
        movingImageAnimation.path = path.cgPath
        movingImageAnimation.duration = 0.25
        movingImageAnimation.fillMode = .forwards
        movingImageAnimation.isRemovedOnCompletion = false
        return movingImageAnimation
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurView.effect = blurEffect
        blurView.frame = contactsVC.view.frame
        blurView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeInfoMenuView))
        blurView.addGestureRecognizer(tapGesture)
        let window = UIApplication.shared.windows[0]
        window.addSubview(blurView)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func blurEffectAnim() -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.3
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        return anim
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        let view1 = setupInfoMenuButtons("square.and.pencil")
        let view2 = setupInfoMenuButtons("map")
        let view3 = setupInfoMenuButtons("person.badge.minus")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        let constraints = [
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            view1.widthAnchor.constraint(equalToConstant: 40),
            view2.widthAnchor.constraint(equalToConstant: 40),
            view3.widthAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
        stackView.alpha = 0
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupInfoMenuButtons(_ imageName: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.tintColor = .black
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.layer.cornerRadius = button.frame.size.width / 2
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 5
        button.backgroundColor = .white
        button.transform = CGAffineTransform(rotationAngle: 2.5)
        stackView.addArrangedSubview(button)
        if imageName == "square.and.pencil" {
            button.addTarget(self, action: #selector(writeMessage), for: .touchUpInside)
        }else if imageName == "map"{
            button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        }else{
            button.addTarget(self, action: #selector(removeFriend), for: .touchUpInside)
        }
        return button
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func writeMessage() {
        let controller = ChatVC()
        controller.modalPresentationStyle = .fullScreen
        controller.friend = friend
        exitInfoMenuHandler()
        contactsVC.show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func openMap() {
        let mapVC = MapsVC()
        mapVC.zoomToSelectedFriend(friend: friend)
        mapVC.modalPresentationStyle = .fullScreen
        exitInfoMenuHandler()
        contactsVC.show(mapVC, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func removeFriend() {
        let controller = AddFriendVC()
        controller.modalPresentationStyle = .fullScreen
        controller.user = friend
        exitInfoMenuHandler()
        contactsVC.show(controller, sender: nil)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc func closeInfoMenuView() {
        closingAnimation()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: CLOSE ANIM METHOD
    
    func closingAnimation() {
        blurView.removeFromSuperview()
        stackView.isHidden = true
        infoName.layer.removeAllAnimations()
        infoName.font = UIFont(name: "Helvetica Neue", size: 18)
        infoEmail.layer.removeAllAnimations()
        infoImage.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
            self.layer.cornerRadius = 0
            self.frame = self.cellFrame
        }) { (true) in
            self.exitInfoMenuHandler()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    func exitInfoMenuHandler(){
        blurView.removeFromSuperview()
        removeFromSuperview()
        cell.isHidden = false
        contactsVC.tableView.isUserInteractionEnabled = true
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

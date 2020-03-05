//
//  WelcomeVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/20/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class WelcomeVC: UIViewController {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // WelcomeVC: INFO ABOUT mChat. This is the first view that user is going to see once he/she launches the app. (If it is her/his first time using this app.)
    
    let welcomePages = [
        WelcomePage(imageName: "Logo-Light", topicText: "mChat", descriptionText: "The messaging app."),
        WelcomePage(imageName: "Chat", topicText: "Chat", descriptionText: "Contact your friends by sending them text, audio or media messages."),
        WelcomePage(imageName: "MapsHome", topicText: "Maps", descriptionText: "Share your location with your friends."),
        WelcomePage(imageName: "Design", topicText: "Design", descriptionText: "Make your messenger look the way you like it."),
        WelcomePage(imageName: "WelcomeEnd", topicText: "Start Messaging", descriptionText: "")
    ]
    var collectionView: UICollectionView!
    var skipButton = UIButton(type: .system)
    var pageControl = UIPageControl()
    var slideAnimView = AnimationView()
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupSkipButton()
        setupPageControl()
        setupAnimView()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(WelcomeCell.self, forCellWithReuseIdentifier: "cellId")
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupSkipButton() {
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        skipButton.tintColor = ThemeColors.mainColor
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        let constraints = [
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.numberOfPages = welcomePages.count
        pageControl.currentPageIndicatorTintColor = ThemeColors.mainColor
        pageControl.pageIndicatorTintColor = ThemeColors.secondaryColor
        pageControl.isUserInteractionEnabled = false
        let constraints = [
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    private func setupAnimView() {
        view.addSubview(slideAnimView)
        slideAnimView.translatesAutoresizingMaskIntoConstraints = false
        slideAnimView.animation = Animation.named("slideInstructions")
        slideAnimView.backgroundBehavior = .pauseAndRestore
        slideAnimView.loopMode = .loop
        slideAnimView.play()
        let constraints = [
            slideAnimView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slideAnimView.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: -32),
            slideAnimView.widthAnchor.constraint(equalToConstant: 100),
            slideAnimView.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: SKIP BUTTON PRESSED METHOD
    
    @objc private func skipButtonPressed() {
        let indexPath = IndexPath(item: welcomePages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = welcomePages.count - 1
        goToSignInController()
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    // MARK: ANIMATION TO SIGN IN VIEW
    
    func goToSignInController() {
        let transitionView = UIView(frame: CGRect(x: view.center.x, y: view.center.y, width: 100, height: 100))
        view.addSubview(transitionView)
        transitionView.layer.cornerRadius = 50
        transitionView.layer.masksToBounds = true
        let gradient = setupGradientLayer()
        gradient.frame = view.bounds
        transitionView.layer.insertSublayer(gradient, at: 0)
        let timer = Timer(timeInterval: 0.3, target: self, selector: #selector(self.animateLogo), userInfo: nil, repeats: false)
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            transitionView.transform = CGAffineTransform(scaleX: 20, y: 20)
            RunLoop.current.add(timer, forMode: .default)
        })
    }
 
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
 
    @objc private func animateLogo(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.center = CGPoint(x: view.center.x, y: view.center.y)
        imageView.image = UIImage(named: "Logo-Light")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(rotationAngle: 720)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            imageView.transform = .identity
            imageView.alpha = 1
        }) { (true) in
            self.animateLogoLabel()
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    @objc private func animateLogoLabel(){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.center = CGPoint(x: view.center.x, y: view.center.y + 150)
        label.font = UIFont(name: "Alata", size: 48)
        label.text = "mChat"
        label.textAlignment = .center
        label.textColor = .white
        view.addSubview(label)
        label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            label.transform = .identity
        }) { (true) in
            let controller = SignInVC()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

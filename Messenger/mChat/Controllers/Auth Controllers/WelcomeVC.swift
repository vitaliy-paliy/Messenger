//
//  WelcomeVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 1/20/20.
//  Copyright © 2020 PALIY. All rights reserved.
//

import UIKit
import Lottie

class AppColors {
    static var mainColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1)
    static var secondaryColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 0.5)
}

struct WelcomePage {
    let imageName: String?
    let topicText: String?
    let descriptionText: String?
}

class WelcomeVC: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupSkipButton()
        setupPageControl()
        setupAnimView()
    }
    
    func setupCollectionView() {
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
    
    func setupSkipButton() {
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        skipButton.tintColor = AppColors.mainColor
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        let constraints = [
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.numberOfPages = welcomePages.count
        pageControl.currentPageIndicatorTintColor = AppColors.mainColor
        pageControl.pageIndicatorTintColor = AppColors.secondaryColor
        pageControl.isUserInteractionEnabled = false
        let constraints = [
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAnimView() {
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
    
    @objc func skipButtonPressed() {
        let indexPath = IndexPath(item: welcomePages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = welcomePages.count - 1
        goToSignInController()
    }
    
    func goToSignInController() {
        let transitionView = UIView(frame: CGRect(x: view.center.x, y: view.center.y, width: 100, height: 100))
        let window = UIApplication.shared.windows[0]
        window.addSubview(transitionView)
        transitionView.backgroundColor = AppColors.mainColor
        transitionView.layer.cornerRadius = 50
        transitionView.layer.masksToBounds = true
        let timer = Timer(timeInterval: 0, target: self, selector: #selector(self.animateLogo), userInfo: nil, repeats: false)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            transitionView.transform = CGAffineTransform(scaleX: 20, y: 20)
            RunLoop.current.add(timer, forMode: .default)
        })
    }
 
    @objc func animateLogo(){
        let window = UIApplication.shared.windows[0]
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.center = CGPoint(x: view.center.x, y: view.center.y)
        imageView.image = UIImage(named: "Logo-Light")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        window.addSubview(imageView)
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(rotationAngle: 360)
        let timer = Timer(timeInterval: 0, target: self, selector: #selector(animateLogoLabel), userInfo: nil, repeats: false)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            imageView.transform = .identity
            imageView.alpha = 1
            RunLoop.current.add(timer, forMode: .default)
        }) { (true) in
            print("Finished")
        }
    }
    
    @objc func animateLogoLabel(){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.center = CGPoint(x: view.center.x, y: view.center.y + 150)
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "mChat"
        label.textColor = .white
        let window = UIApplication.shared.windows[0]
        window.addSubview(label)
        label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            label.transform = .identity
        }) { (true) in
            let controller = SignInVC()
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
}

extension WelcomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xValue = targetContentOffset.pointee.x
        let pageNum = Int(xValue / view.frame.width)
        pageControl.currentPage = pageNum
        if pageNum != welcomePages.count - 1 {
            skipButton.isHidden = false
        }else{
            goToSignInController()
            skipButton.isHidden = true
        }
        if pageControl.currentPage > 0 { slideAnimView.isHidden = true } else { slideAnimView.isHidden = false }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return welcomePages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! WelcomeCell
        let welcomePage = welcomePages[indexPath.row]
        cell.page = welcomePage
        cell.welcomeVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let welcomeCell = cell as! WelcomeCell
        welcomeCell.topicImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        welcomeCell.descriptionLabel.transform = CGAffineTransform(translationX: view.frame.origin.x + view.frame.width/2, y: 0)
        welcomeCell.signInButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            welcomeCell.topicImage.transform = .identity
            welcomeCell.descriptionLabel.transform = .identity
            welcomeCell.signInButton.transform = .identity
        })
    }
    
}

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
    static var mainColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 1)
    static var secondaryColor = UIColor(red: 70/255, green: 100/255, blue: 200/255, alpha: 0.2)
}

struct WelcomePage {
    let imageName: String?
    let topicText: String?
    let descriptionText: String?
}

class WelcomeVC: UIViewController {
    
    let welcomePages = [
        WelcomePage(imageName: "logo", topicText: "mChat", descriptionText: "The messaging app."),
        WelcomePage(imageName: "Chat", topicText: "Chat", descriptionText: "Contact your friends by sending them text, audio or media messages."),
        WelcomePage(imageName: "MapsHome", topicText: "Maps", descriptionText: "Share your location with your friends."),
        WelcomePage(imageName: "Design", topicText: "Design", descriptionText: "Make your messenger look the way you like it."),
        WelcomePage(imageName: "WelcomeEnd", topicText: "Start Messaging", descriptionText: "")
    ]
    var collectionView: UICollectionView!
    var skipButton = UIButton(type: .system)
    var nextButton = UIButton(type: .system)
    var previousButton = UIButton(type: .system)
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupSkipButton()
        setupPageControl()
        setupnextButton()
        setupPreviousButton()
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
    
    func setupnextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        nextButton.tintColor = AppColors.mainColor
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        let constraints = [
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
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
        let constraints = [
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPreviousButton(){
        view.addSubview(previousButton)
        previousButton.isHidden = true
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setTitle("PREVIOUS", for: .normal)
        previousButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        previousButton.tintColor = AppColors.mainColor
        previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        let constraints = [
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func nextButtonPressed(){
        if pageControl.currentPage == welcomePages.count - 1 {
            nextButton.isHidden = true
            skipButton.isHidden = true
            return
        }
        let pageNum = min(pageControl.currentPage + 1, welcomePages.count - 1)
        if pageNum > 0 { previousButton.isHidden = false }
        pageControl.currentPage = pageNum
        let indexPath = IndexPath(item: pageNum, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func previousButtonPressed() {
        if pageControl.currentPage == 0 {
            previousButton.isHidden = true
            return
        }
        let pageNum = max(pageControl.currentPage - 1, 0)
        if pageNum > 0 {
            nextButton.isHidden = false
            skipButton.isHidden = false
        }
        pageControl.currentPage = pageNum
        let indexPath = IndexPath(item: pageNum, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func skipButtonPressed() {
        let indexPath = IndexPath(item: welcomePages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = welcomePages.count - 1
        previousButton.isHidden = false
        nextButton.isHidden = true
        skipButton.isHidden = true
    }
    
    func goToSignUpController(){
        print("ADD ANIMATION")
        let controller = SignUpVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
    func goToSignInController() {
        let controller = SignInVC()
        controller.modalPresentationStyle = .fullScreen
        show(controller, sender: nil)
    }
    
}

extension WelcomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xValue = targetContentOffset.pointee.x
        let pageNum = Int(xValue / view.frame.width)
        pageControl.currentPage = pageNum
        if pageNum != welcomePages.count - 1 {
            nextButton.isHidden = false
            skipButton.isHidden = false
        }else{
            nextButton.isHidden = true
            skipButton.isHidden = true
        }
        if pageNum > 0 {
            previousButton.isHidden = false
        }else{
            previousButton.isHidden = true
        }
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
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            welcomeCell.topicImage.transform = .identity
            welcomeCell.descriptionLabel.transform = .identity
        })
    }
    
}

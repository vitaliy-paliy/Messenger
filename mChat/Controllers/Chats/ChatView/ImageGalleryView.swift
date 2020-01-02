//
//  ImageGalleryView.swift
//  mChat
//
//  Created by Vitaliy Paliy on 12/31/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit

class SelectedImageView: UIScrollView, UIScrollViewDelegate{
    
    var keyWindow: UIWindow!
    var chatVC: ChatVC!
    var cellImage: UIImageView!
    var cellFrame: CGRect!
    var imageView = UIImageView()
    
    init(_ cellImage: UIImageView, _ chatVC: ChatVC) {
        super.init(frame: .zero)
        self.cellImage = cellImage
        self.chatVC = chatVC
        self.cellImage.isHidden = true
        cellFrame = cellImage.superview?.convert(cellImage.frame, to: nil)
        keyWindow = UIApplication.shared.windows[0]
        setupScrollView()
        setupSelectedImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        frame = chatVC.view.frame
        keyWindow.addSubview(self)
        backgroundColor = .black
        delegate = self
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = true
        flashScrollIndicators()
        minimumZoomScale = 1
        maximumZoomScale = 3
        setupGestures()
    }
    
    func setupGestures(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(swipeUp)
        addGestureRecognizer(swipeDown)
        addGestureRecognizer(doubleTapGesture)
    }
    
    func setupSelectedImage() {
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
    
    @objc func handleSwipe() {
        removeFromSuperview()
        chatVC.view.addSubview(imageView)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.imageView.frame = self.cellFrame
            self.imageView.layer.cornerRadius = self.cellImage.layer.cornerRadius
            self.imageView.layer.masksToBounds = true
        }) { (true) in
            self.imageView.removeFromSuperview()
            self.cellImage.isHidden = false
        }
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        print("doubletapped")
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(scale: maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: self)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

//
//  ChatTabBar.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/17/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class ChatTabBar: UITabBarController{
    
    var itemBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupVC()
    }
    
    var direction: CGFloat = 0
    
    func setupTabBar(){
        tabBar.layer.cornerRadius = 12
        tabBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tabBar.layer.masksToBounds = true
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems - 20, height: tabBar.frame.height)
        var yValue: CGFloat = 44
        if tabBarItemSize.height < 50 {
            yValue = 40
        }
        itemBackgroundView = UIView(frame: CGRect(x: tabBarItemSize.width / 2, y: yValue, width: 6, height: 6))
        itemBackgroundView.backgroundColor = .white
        itemBackgroundView.layer.cornerRadius = 3
        itemBackgroundView.alpha = 0
        tabBar.addSubview(itemBackgroundView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let index = -(tabBar.items?.firstIndex(of: tabBar.selectedItem!)?.distance(to: 0))!
        let frame = frameForTabAtIndex(index: index)
        itemBackgroundView.center.x = frame.origin.x + frame.width/2
        itemBackgroundView.alpha = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = -(tabBar.items?.firstIndex(of: item)?.distance(to: 0))!
        let frame = frameForTabAtIndex(index: index)
        let completedFrame = frame.origin.x + frame.width/2
        var dirNum = 1
        if direction > completedFrame {
            dirNum = -1
        }else if direction < completedFrame{
            dirNum = 1
        }else{
            dirNum = 0
        }
        direction = completedFrame
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.itemBackgroundView.center.x = completedFrame + CGFloat(10 * dirNum)
        }) { (true) in
            self.itemBackgroundView.center.x = completedFrame
        }
    }
    
    func frameForTabAtIndex(index: Int) -> CGRect {
        var frames = tabBar.subviews.compactMap { (view:UIView) -> CGRect? in
            if let view = view as? UIControl {
                for item in view.subviews {
                    if let image = item as? UIImageView {
                        return image.superview!.convert(image.frame, to: tabBar)
                    }
                }
                return view.frame
            }
            return nil
        }
        frames.sort { $0.origin.x < $1.origin.x }
        if frames.count > index {
            return frames[index]
        }
        return frames.last ?? CGRect.zero
    }
    
    func setupVC(){
        let chats = UINavigationController(rootViewController: ConversationsVC())
        let contacts = UINavigationController(rootViewController: ContactsVC())
        let settings = UINavigationController(rootViewController: SettingsVC())
        chats.tabBarItem.image = UIImage(systemName: "message.fill")
        contacts.tabBarItem.image = UIImage(systemName: "person.fill")
        settings.tabBarItem.image = UIImage(systemName: "gear")
        viewControllers = [contacts,chats,settings]
    }
    
}

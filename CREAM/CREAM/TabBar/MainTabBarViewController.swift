//
//  MainTabBarViewController.swift
//  CREAM
//
//  Created by Kant on 2022/05/04.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: StyleViewController())
        let vc3 = UINavigationController(rootViewController: ShopViewController())
        let vc4 = UINavigationController(rootViewController: WatchViewController())
        let vc5 = UINavigationController(rootViewController: MyViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart.text.square")
        vc3.tabBarItem.image = UIImage(systemName: "cart")
        vc4.tabBarItem.image = UIImage(systemName: "arrowtriangle.right.circle.fill")
        vc5.tabBarItem.image = UIImage(systemName: "person.circle")
        
        vc1.title = "HOME"
        vc2.title = "STYLE"
        vc3.title = "SHOP"
        vc4.title = "WATCH"
        vc5.title = "MY"
        
        tabBar.tintColor = .label
        setViewControllers([vc1,vc2,vc3,vc4,vc5], animated: true)
    }
}

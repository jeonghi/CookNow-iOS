//
//  AppAppearance.swift
//  App
//
//  Created by 쩡화니 on 6/14/24.
//

import UIKit
import DesignSystem
import DesignSystemFoundation

enum AppAppearance {
  static func configure() {
    configureTabBarAppearance()
    configureNavigationBarApperance()
  }
  
  private static func configureNavigationBarApperance() {
    
    // UINavigationBarApperance
    let appearance = UINavigationBarAppearance()
    
    let titleTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.asset(.black),
    ]
    
    appearance.titleTextAttributes = titleTextAttributes
    appearance.backgroundColor = .asset(.white)
    
    // UINavigationBar.appearance()
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.standardAppearance = appearance
    navigationBarAppearance.scrollEdgeAppearance = appearance
  }
  
  private static func configureTabBarAppearance() {
    
    // UITabBarAppearance()
    let appearance = UITabBarAppearance()
//    
    appearance.configureWithDefaultBackground()
//    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .asset(.white)
//    
    // UITabBar.appearance()
    let tabBarAppearance = UITabBar.appearance()
//    
    tabBarAppearance.tintColor = UIColor.asset(.primary700)
//    tabBarAppearance.isTranslucent = false
//    tabBarAppearance.standardAppearance = appearance
//    tabBarAppearance.scrollEdgeAppearance = appearance
//    tabBarAppearance.layer.cornerRadius = 30
//    tabBarAppearance.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
  }
}

#if(DEBUG)

#Preview {
  AppAppearance.configure()
  
  let rootVC = UITabBarController()
  
  let vc1 = UIViewController()
  let vc2 = UIViewController()
  
  vc1.view.backgroundColor = .darkGray
  vc2.view.backgroundColor = .lightGray
  
  vc1.tabBarItem = UITabBarItem(
    title: "Home",
    image: UIImage(systemName: "house.fill"),
    tag: 0
  )
  vc2.tabBarItem = UITabBarItem(
    title: "Settings",
    image: UIImage(
      systemName: "gearshape.fill"
    ),
    tag: 1
  )
  
  rootVC.setViewControllers([vc1, vc2], animated: false)
  
  let navVC = UINavigationController(rootViewController: rootVC)
  return navVC
}

#endif

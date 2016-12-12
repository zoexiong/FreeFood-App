//
//  TabBarViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/12/6.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

let userDefault = UserDefaults.standard


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Events" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
            self.dismiss(animated: true, completion: {})
        }
        if item.title == "Food" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier2"), object: nil)
            self.dismiss(animated: true, completion: {})
        }
    }
    // UITabBarControllerDelegate
    //    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    //        print("Selected view controller")
    //    }
    //
    override func viewDidLoad() {
        self.delegate = self
        super.viewDidLoad()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

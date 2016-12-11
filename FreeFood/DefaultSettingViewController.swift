//
//  DefaultSettingViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/12/7.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

class DefaultSettingViewController: UIViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBOutlet weak var screenSwtich: UISwitch!
    
    
    
    @IBAction func screenSave(_ sender: Any) {
        
        //        toogle to change the user default data
        if screenSwtich.isOn{
            userDefault.set(2, forKey: "initialTab")
        } else {
            userDefault.set(1, forKey: "initialTab")
        }
        
        defaultData.userscreen = userDefault.integer(forKey: "initialTab")
        
        userDefault.synchronize()
        
        
        self.dismiss(animated: true, completion: {})
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch(defaultData.userscreen){
        case 1:
            screenSwtich.setOn(false, animated: true)
        case 2:
            screenSwtich.setOn(true, animated: true)
        default:
            screenSwtich.setOn(false, animated: true)
        }
        
        
        // Do any additional setup after loading the view.
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

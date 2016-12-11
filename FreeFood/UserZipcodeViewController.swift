//
//  UserZipcodeViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/12/7.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

class UserZipcodeViewController: UIViewController {
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    
    
    @IBOutlet weak var ziptext: UITextField!
    
    @IBAction func zipSave(_ sender: Any) {
        //zipcode
        let zipInput = ziptext.text!
        //stored zip data
        if (zipInput != "") {
            userDefault.set(zipInput, forKey: "zipcode")
            defaultData.userzip = userDefault.string(forKey: "zipcode")!
            
            userDefault.synchronize()
            
            self.dismiss(animated: true, completion: {})
            
        }else{
            
            let alertController = UIAlertController(title: "Try Again", message:
                "New zipcode cannot be empty. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    
    //send alert to notify change
    override func viewDidLoad() {
        super.viewDidLoad()
        ziptext.clearButtonMode = .whileEditing
        
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

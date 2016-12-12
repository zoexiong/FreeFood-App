//
//  WebViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/27.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    var urlLink: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlLink2: URL
        
        
        urlLink2 = URL(string: urlLink)!
        
        /*
         if urlLink.hasPrefix("www") {
         urlLink2 = URL(string: urlLink)!
         } else {
         urlLink2 = URL(string: "www." + (urlLink))!
         }
         */
        if urlLink.contains("http") {
            urlLink2 = URL(string: urlLink)!
        } else {
            urlLink2 = URL(string: "https://" + (urlLink))!
        }
        
        
        /*
         print("THUS PAGE")
         print(urlLink2)
         */
        webview.loadRequest(URLRequest(url: urlLink2))
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

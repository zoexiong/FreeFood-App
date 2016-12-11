//
//  EventDetailViewController.swift
//  FreeFood
//
//  Created by Xuan Liu on 2016/11/27.
//  Copyright © 2016年 Xuan Liu. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    //this view will show modally like a pop up
    
    var eventSelected : Event = Event()
    
    @IBOutlet weak var eventName: UILabel!//the title of the event
    
    @IBOutlet weak var eventFoods: UILabel! //a list of food served, can go mutiple lines
    
    @IBOutlet weak var eventTime: UILabel! //time and date od the event
    
    @IBOutlet weak var eventLocation: UILabel!//address of the location, can go multiple lines
    
    @IBOutlet weak var eventDescription: UILabel!//multiple lines, can be empty if not available
    
    @IBOutlet weak var detailButton: UIButton! //optional, could be hidden if no url available
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailButton.isHidden = true //by default, no url link available, so the button is hidden
        showEventDetails()
        //check url, when available, isHidden = false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showEventDetails() {
        //print(eventSelected.eventName)
        //eventName.text = eventSelected.eventName
        eventName.text = eventSelected.eventName
        eventFoods.text = eventSelected.eventFoods
        eventTime.text = eventSelected.eventDate + "    " + eventSelected.eventStartTime+" to "+eventSelected.eventEndTime
        eventLocation.text = eventSelected.eventLocation
        eventDescription.text = eventSelected.eventDescription
        if (eventSelected.eventUrl.characters.count > 0) {
            detailButton.isHidden = false
        }
    }
    
    @IBAction func RSVPButton(_ sender: Any) {
        self.performSegue(withIdentifier: "RSVPVC", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RSVPVC" {
            let viewController = segue.destination as! WebViewController
            viewController.urlLink = eventSelected.eventUrl
        }
    }
}

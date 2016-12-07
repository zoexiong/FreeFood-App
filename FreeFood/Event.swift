//
//  Event.swift
//  FreeFood
//
//  Created by Arjun Lalwani on 02/12/16.
//  Copyright © 2016 Xuan Liu. All rights reserved.
//

import Foundation

class Event{
    var eventName:String
    var eventLocation:String
    var eventFoods:String
    var eventTime:String
    var eventDescription:String
    var eventUrl:String
    
    convenience init() {
        self.init(eventName: "", eventTime: "", eventLocation: "", eventFoods: "", eventDescription: "", eventUrl: "")
    }
    
    init(eventName:String, eventTime:String, eventLocation:String, eventFoods:String, eventDescription: String, eventUrl: String) {
        self.eventName=eventName
        self.eventTime=eventTime
        self.eventLocation=eventLocation
        self.eventFoods=eventFoods
        self.eventDescription = eventDescription
        self.eventUrl = eventUrl
    }
    
}

struct Constants {
    struct Event2 {
        static let eventName = "Name"
        static let eventLocation = "Location"
        static let eventStartTime = "StartTime"
        static let eventEndTime = "EndTime"
        static let eventFoods = [Food]()
        static let eventDescription = "Description"
        static let eventUrl = "Url"
        static let evventZipCode = "Zipcode"
    }
}

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
    var eventStartTime:String
    var eventEndTime:String
    var eventDate:String
    var eventDescription:String
    var eventUrl:String
 //   var eventZipcode:String
    
    convenience init() {
        self.init(eventName: "", eventStartTime: "", eventEndTime: "", eventDate: "", eventLocation: "", eventFoods: "", eventDescription: "", eventUrl: "")
    }
    
    init(eventName:String, eventStartTime:String, eventEndTime:String, eventDate:String, eventLocation:String, eventFoods:String, eventDescription: String, eventUrl: String) {
        self.eventName=eventName
        self.eventStartTime=eventStartTime
        self.eventEndTime=eventEndTime
        self.eventDate=eventDate
        self.eventLocation=eventLocation
        self.eventFoods=eventFoods
        self.eventDescription = eventDescription
        self.eventUrl = eventUrl
        //self.eventZipcode = eventZipcode
    }
    
}

struct Constants {
    struct Event2 {
        static let eventName = "Name"
        static let eventLocation = "Location"
        static let eventDate = "Date"
        static let eventStartTime = "StartTime"
        static let eventEndTime = "EndTime"
        static let eventFoods = "Foods"
        static let eventDescription = "Description"
        static let eventUrl = "Url"
        static let eventZipcode = "Zipcode"

    }
}

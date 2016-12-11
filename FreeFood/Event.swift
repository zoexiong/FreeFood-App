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
    var eventZipcode:String
    var eventUrl:String

    
    convenience init() {
        self.init(eventName: "", eventZipcode:"", eventStartTime: "", eventEndTime: "", eventDate: "", eventLocation: "", eventFoods: "", eventDescription: "", eventUrl: "")
    }
    
    init(eventName:String, eventZipcode:String, eventStartTime:String, eventEndTime:String, eventDate:String, eventLocation:String, eventFoods:String, eventDescription: String, eventUrl: String) {
        self.eventName=eventName
        self.eventStartTime=eventStartTime
        self.eventEndTime=eventEndTime
        self.eventDate=eventDate
        self.eventLocation=eventLocation
        self.eventFoods=eventFoods
        self.eventDescription = eventDescription
        self.eventZipcode = eventZipcode
        self.eventUrl = eventUrl

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

class Events{
    var events:[Event] = []
    init(events:[Event]){
    self.events = events
    }
}

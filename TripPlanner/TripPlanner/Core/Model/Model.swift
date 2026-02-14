//
//  Model.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

struct Trip: Codable, Identifiable {
    
    let id: String
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var activities: [Activity]
    var hotels: [Hotel]
    var flights: [Flight]
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey{
        
        case id, name, destination, startDate, endDate, activities, hotels, flights, imageURL
    }
    
}

struct Activity: Codable, Identifiable {
    
    let id: String
    var name: String
    var description: String
    var date: String
    var location: String
    
    enum Codingkeys: String, CodingKey {
        
        case id, name, description, date, location
    }
}

struct Hotel: Codable, Identifiable {
    let id: String
    var name: String
    var location: String
    var checkInDate: Date
    var checkOutDate: Date
    var price: Double
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, location, checkInDate, checkOutDate, price, imageURL
    }
}

struct Flight: Codable, Identifiable {
    
    let id: String
    let airline: String
    var departureTime: Date
    var arrivalTime: Date
    var price: Double
    var from: String
    var to: String
    var duration: String
    
    enum CodingKeys: String, CodingKey {
         case id, airline, departureTime, arrivalTime, price, from, to, duration
     }
    
}

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

    enum CodingKeys: String, CodingKey {
        case id, name, destination, startDate, endDate
    }
}

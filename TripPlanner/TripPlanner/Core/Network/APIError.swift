//
//  APIError.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

enum APIError: LocalizedError {
    
    case invalidURL
    case invalidResponse
    case NetworkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "failed to decode response"
        case .NetworkError(let error):
            return error.localizedDescription
        }
    }
}

//
//  APIError.swift
//  ECommerce
//
//  Created by Nishita Shukla on 28/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation
enum APIError: String, Error
{
    case invalidURL         = "Invalid URL. Please try gain"
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from server. Please try again"
    case invalidData        = "The Data receieved from the server was invalid. Please try again"
    case invalidPostData    = "Invalid Post Data: Pass 'Data' Type."
}

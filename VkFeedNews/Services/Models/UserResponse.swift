//
//  UserResponse.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.07.2021.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}


struct UserResponse: Decodable {
    let photo100: String?
}

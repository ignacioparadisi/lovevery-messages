//
//  MessageAPI.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

enum MessagesAPI: API {
    case getAllChats
    case getChatByUser(user: String)
    case createMessage(message: MessageBody)
    
    var method: HTTPMethod {
        switch self {
        case .getAllChats, .getChatByUser:
            return .get
        case .createMessage:
            return .post
        }
    }
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var host: String {
        return "abraxvasbh.execute-api.us-east-2.amazonaws.com"
    }
    
    var path: String {
        switch self {
        case .createMessage:
            return "/proto/messages"
        case .getAllChats:
            return "/proto/messages"
        case .getChatByUser(let user):
            return "/proto/messages/\(user)"
        }
    }
    
    var parameters: [URLQueryItem] {
        return []
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createMessage(let message):
                return message
        default:
            return nil
        }
    }
}

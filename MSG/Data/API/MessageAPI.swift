//
//  MessageAPI.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

enum MessagesAPI: API {
    case getAllMessages
    case getMessagesByUser(user: String)
    case createMessage(message: MessageBody)
    
    var method: HTTPMethod {
        switch self {
        case .getAllMessages, .getMessagesByUser:
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
        case .getAllMessages:
            return "/proto/messages"
        case .getMessagesByUser(let user):
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

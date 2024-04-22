//
//  MSGTests.swift
//  MSGTests
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import XCTest
@testable import MSG

final class MSGTests: XCTestCase {
    
    private let dataSource = AWSDataSource(client: HTTPClient(session: MockURLProtocol.session))

    func testGetMessagesSuccess() async throws {
        let data = try JSONReader().read(path: "get_messages")
        MockURLProtocol.setHandler(url: MessagesAPI.getAllMessages.url!, data: data, statusCode: 200)
        let response = try await dataSource.getMessages()
        XCTAssertEqual(response.count, 2)
        XCTAssert(response.keys.contains("Dan"))
        XCTAssertEqual(response["Dan"]?.count, 2)
    }

    func testGetMessagesForUserSuccess() async throws {
        let data = try JSONReader().read(path: "get_messages_for_user")
        MockURLProtocol.setHandler(url: MessagesAPI.getMessagesByUser(user: "Dan").url!, data: data, statusCode: 200)
        let response = try await dataSource.getMessages(for: "Dan")
        XCTAssertEqual(response.user, "Dan")
        XCTAssertEqual(response.message.count, 1)
    }
    
    func testCreateMessage() async throws {
        let data = try JSONReader().read(path: "create_new_message")
        let message = Message(subject: "pets", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi quis ex id ante scelerisque elementum. Praesent fringilla diam vitae ligula aliquam, eu molestie dui blandit. Donec scelerisque arcu quis tellus scelerisque, vitae scelerisque elit auctor. Integer elementum luctus interdum. Mauris lacinia, turpis vel euismod dignissim, felis erat suscipit erat, vitae commodo dolor orci eget neque. Aenean interdum dolor ut fringilla semper. Quisque porta ut dui non sodales. Suspendisse a quam nec velit vehicula vehicula vel et nisi. Suspendisse potenti. Fusce in mattis ex.")
        let body = MessageBody(user: "Dan", message: message, operation: "add_message")
        let url = MessagesAPI.createMessage(message: body).url!
        MockURLProtocol.setHandler(url: url, data: data, statusCode: 200)
        let response = try await dataSource.sendMessage(user: "Dan", message: message)
        XCTAssertEqual(response.user, "Dan")
        XCTAssertEqual(response.subject, "pets")
        XCTAssertEqual(response.message, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi quis ex id ante scelerisque elementum. Praesent fringilla diam vitae ligula aliquam, eu molestie dui blandit. Donec scelerisque arcu quis tellus scelerisque, vitae scelerisque elit auctor. Integer elementum luctus interdum. Mauris lacinia, turpis vel euismod dignissim, felis erat suscipit erat, vitae commodo dolor orci eget neque. Aenean interdum dolor ut fringilla semper. Quisque porta ut dui non sodales. Suspendisse a quam nec velit vehicula vehicula vel et nisi. Suspendisse potenti. Fusce in mattis ex.")
    }

}

//
//  JSONReader.swift
//  MSGTests
//
//  Created by Ignacio Paradisi on 4/22/24.
//

import Foundation

final class JSONReader {
    enum Errors: Error {
        case invalidPath
    }
    func read(path: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.path(forResource: path, ofType: "json") else {
            throw Errors.invalidPath
        }
        let url = URL(filePath: filePath)
        return try Data(contentsOf: url)
    }
}

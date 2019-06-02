//
//  Parser.swift
//  JSONParser
//
//  Created by BLU on 2019. 5. 29..
//  Copyright © 2019년 JK. All rights reserved.
//

import Foundation

struct Parser {
    
    enum Error: Swift.Error {
        case invalidToken(Token)
        
        var localizedDescription: String {
            switch self {
            case .invalidToken(let token):
                return "유효하지 않은 토큰 \(token.description) 입니다."
            }
        }
    }
    
    private let tokens: [Token]
    private var position = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    private mutating func getNextToken() -> Token? {
        guard position < tokens.count else {
            return nil
        }
        let token = tokens[position]
        position += 1
        return token
    }
    
    private mutating func getString() -> String {
        var value = ""
        
        while let token = getNextToken(), token != .doubleQuotation {
            value = value + token.description
        }
        return value
    }
    
    mutating func parse() throws -> [JSON] {
        var jsonArray = [JSON]()
        var numberOfComma = 0
        
        if let token = getNextToken(), token != .openSquareBracket {
            throw Parser.Error.invalidToken(token)
        }
        
        while let token = getNextToken() {
            switch token {
            case .doubleQuotation:
                let stringValue = getString()
                jsonArray.append(.string(stringValue))
            case .number(let number):
                jsonArray.append(.number(number))
            case .comma:
                if jsonArray.count - 1 == numberOfComma && position != tokens.endIndex {
                    numberOfComma = numberOfComma + 1
                    continue
                }
            case .bool(let bool):
                jsonArray.append(.bool(bool))
            case .string, .openSquareBracket:
                throw Parser.Error.invalidToken(token)
            case .closeSquareBracket:
                if tokens.count != tokens.endIndex {
                    throw Parser.Error.invalidToken(token)
                }
            }
        }
        return jsonArray
    }
}

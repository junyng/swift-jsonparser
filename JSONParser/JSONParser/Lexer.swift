//
//  Lexer.swift
//  JSONParser
//
//  Created by BLU on 2019. 5. 29..
//  Copyright © 2019년 JK. All rights reserved.
//

import Foundation

struct Lexer {
    
    enum Error: Swift.Error {
        case invalidCharacter(Character)
    }
    
    private let input: String
    private(set) var position: String.Index
    
    init(input: String) {
        self.input = input
        self.position = self.input.startIndex
    }
    
    private func peek() -> Character? {
        guard position < input.endIndex else {
            return nil
        }
        return input[position]
    }
    
    private mutating func advance() {
        position = input.index(after: position)
    }
    
    private mutating func getString() -> String {
        var value = ""
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "a" ... "z", "A" ... "Z":
                let stringValue = String(nextCharacter)
                value = value + stringValue
                advance()
            default:
                return value
            }
        }
        
        return value
    }
    
    private mutating func getNumber() -> Int {
        var value = 0
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                let digitValue = Int(String(nextCharacter)) ?? 0
                value = 10 * value + digitValue
                advance()
            default:
                return value
            }
        }
        
        return value
    }
    
    mutating func tokenize() throws -> [Token] {
        var tokens = [Token]()
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "\"":
                tokens.append(.doubleQuotation)
                advance()
            case "a" ... "z", "A" ... "Z":
                let value = getString()
                tokens.append(.string(value))
            case "0" ... "9":
                let value = getNumber()
                tokens.append(.number(value))
            case ",":
                tokens.append(.comma)
                advance()
            case " ":
                advance()
            default:
                throw Error.invalidCharacter(nextCharacter)
            }
        }
        return tokens
    }
}

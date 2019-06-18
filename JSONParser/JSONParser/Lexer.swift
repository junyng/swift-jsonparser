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
        
        var localizedDescription: String {
            switch self {
            case .invalidCharacter(let character):
                return "유효하지 않은 문자 \(character)가 입력되었습니다."
            }
        }
    }
    
    private let delimeterTokenList: [Character: Token] = [
        Keyword.openSquareBracket: .openSquareBracket,
        Keyword.closeSquareBracket: .closeSquareBracket,
        Keyword.comma: .comma
    ]
    private var reader: Reader
    
    init(reader: Reader) {
        self.reader = reader
    }
    
    mutating func tokenize() throws -> [Token] {
        var tokens = [Token]()
        
        while let token = try nextToken() {
            tokens.append(token)
        }
        
        return tokens
    }
    
    private mutating func nextToken() throws -> Token? {
        guard let nextCharacter = reader.peek() else {
            return nil
        }
        
        if let token = delimeterTokenList[nextCharacter] {
            reader.advance()
            return token
        }
        
        if nextCharacter.isAlphanumeric {
            let string = getString()
            
            if let number = Int(string) {
                return .number(number)
            }
            
            switch string {
            case Keyword.true: return .true
            case Keyword.false: return .false
            default: throw Lexer.Error.invalidCharacter(nextCharacter)
            }
        }
        
        let string = getString()
        let word = StringUtility.removeDoubleQuotations(string)
        return .string(word)
    }
    
    private mutating func getString() -> String {
        var value = ""
        while let nextCharacter = reader.peek(),
            nextCharacter.isAlphanumeric || nextCharacter == Keyword.doubleQuotation {
                value = value + String(nextCharacter)
                reader.advance()
        }
        return value
    }
}

extension Character {
    var isAlphanumeric: Bool {
        return self.isLetter || self.isNumber
    }
}

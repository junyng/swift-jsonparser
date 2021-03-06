//
//  Token.swift
//  JSONParser
//
//  Created by BLU on 2019. 5. 29..
//  Copyright © 2019년 JK. All rights reserved.
//

import Foundation

enum Token: Equatable {
    case openCurlyBracket
    case closeCurlyBracket
    case openSquareBracket
    case closeSquareBracket
    case comma
    case colon
    case string(String)
    case number(Int)
    case bool(Bool)
}

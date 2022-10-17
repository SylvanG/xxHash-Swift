//
//  XXHashError.swift
//  
//
//  Created by Shuaihu on 2022/10/17.
//

import Foundation
import xxHash

public enum XXHashError: Error {
    case stateInitFailed
    case resetStateError
    case updateStateError
}

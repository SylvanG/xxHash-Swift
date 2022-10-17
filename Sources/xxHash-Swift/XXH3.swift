//
//  XXH3.swift
//  
//
//  Created by Shuaihu on 2022/10/17.
//

import Foundation
import xxHash


/**
 * XXH3 is a more recent hash algorithm featuring:
 * Refer to [xxhash.h](https://github.com/Cyan4973/xxHash/blob/v0.8.1/xxhash.h#L738).
 *
 * When only 64 bits are needed, prefer invoking the \_64bits variant, as it
 * reduces the amount of mixing, resulting in faster speed on small inputs.
 * Refer to [xxhash.h](https://github.com/Cyan4973/xxHash/blob/v0.8.1/xxhash.h#L769).
 *
 * Streaming requires state maintenance.
 * This operation costs memory and CPU.
 * As a consequence, streaming is slower than one-shot hashing.
 * For better performance, prefer one-shot functions whenever applicable.
 * Refer to [xxhash.h](https://github.com/Cyan4973/xxHash/blob/v0.8.1/xxhash.h#L825).
 */
public class XXH3 {
    /// Generate digest based on seed. This variant generates a custom secret on the fly based on default secret altered using the `seed` value.
    /// - Parameters:
    ///     - seed: Used to generate secret. If seed==0, using default secret.
    static public func digest64(_ string: String, seed: UInt64 = 0) -> UInt64 {
        return string.withCString { pointer in
            return XXH3_64bits_withSeed(pointer, string.utf8.count, seed)
        }
    }
    
    static public func digest64(_ data: Data, seed: UInt64 = 0) -> UInt64 {
        guard data.count > 0 else {
            return digest64([UInt8](), seed: seed)
        }
        return data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            // If the baseAddress of this buffer is nil, the count is zero. 
            return XXH3_64bits_withSeed(pointer.baseAddress!, data.count, seed)
        }
    }
    
    static public func digest64<S: Sequence>(_ s: S, seed: UInt64 = 0) -> UInt64 where S.Element == UInt8 {
        return digest64([UInt8](s), seed: seed)
    }
    
    static public func digest64(_ input: [UInt8], seed: UInt64 = 0) -> UInt64 {
        // see ``UnsafeRawPointer`` for documentation
        // An immutable pointer to the elements of an array is implicitly created when you pass the array as an argument.
        return XXH3_64bits_withSeed(input, input.count, seed)
    }
    
    /// Steaming API, repeat call ``XX3State`` update method to update the state
    static public func digest64(seed: UInt64 = 0, withState block: (XX3State) throws -> Void) throws -> UInt64 {
        guard let state = XXH3_createState() else {
            throw XXHashError.stateInitFailed
        }
        defer {
            XXH3_freeState(state)
        }
        
        guard XXH3_64bits_reset_withSeed(state, seed) == XXH_OK else {
            throw XXHashError.resetStateError
        }
        
        try block(XX3State(state))
        
        return XXH3_64bits_digest(state)
    }
}


public struct XX3State {
    let state: OpaquePointer
    
    init(_ state: OpaquePointer) {
        self.state = state
    }
    
    func update(_ input: [UInt8]) throws {
        guard XXH3_64bits_update(state, input, input.count) == XXH_OK else {
            throw XXHashError.updateStateError
        }
    }
    
    func update<S: Sequence>(_ s: S) throws where S.Element == UInt8 {
        return try update([UInt8](s))
    }
    
    func update(_ string: String) throws {
        try string.withCString { pointer in
            guard XXH3_64bits_update(state, pointer, string.utf8.count) == XXH_OK else {
                throw XXHashError.updateStateError
            }
        }
    }
    
    func update(_ data: Data) throws {
        guard data.count > 0 else {
            return try update([UInt8]())
        }
        return try data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            // If the baseAddress of this buffer is nil, the count is zero.
            guard XXH3_64bits_update(state, pointer.baseAddress!, data.count) == XXH_OK else {
                throw XXHashError.updateStateError
            }
        }
    }
}

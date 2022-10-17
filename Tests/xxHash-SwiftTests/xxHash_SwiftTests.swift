import XCTest
@testable import xxHash_Swift

final class xxHash_SwiftTests: XCTestCase {
    let PRIME32: UInt32 = 2654435761
    let PRIME64: UInt64 = 11400714785074694797
    let SANITY_BUFFER_SIZE: Int = 2367
    lazy var input: [UInt8] = {
        var result = [UInt8](repeating: 0, count: SANITY_BUFFER_SIZE)
        var byteGen: UInt64 = numericCast(PRIME32)
        for i in 0..<result.count {
            result[i] = numericCast(byteGen >> 56)
            
            // integer overflow operators
            // https://useyourloaf.com/blog/swift-integer-quick-guide/
            byteGen = byteGen &* PRIME64
        }
        return result
    }()
    
    func testXXH3_sanityCheck() {
        // https://github.com/Cyan4973/xxHash/blob/94e5f23e736f2bb67ebdf90727353e65344f9fc0/xxhsum.c#L1246
        testXXH3("", 0, 0x2D06800538D394C2)
        testXXH3("", PRIME64, 0xA8A6B918B2F0364A)
        testXXH3WithSeq(input[0..<1], 0, 0xC44BDFF4074EECDB)
        testXXH3WithSeq(input[0..<1], PRIME64, 0x032BE332DD766EF8)
        testXXH3WithSeq(input[0..<6], 0, 0x27B56A84CD2D7325)
        testXXH3WithSeq(input[0..<6], PRIME64, 0x84589C116AB59AB9)
        testXXH3WithSeq(input[0..<12], 0, 0xA713DAF0DFBB77E7)
        testXXH3WithSeq(input[0..<12], PRIME64, 0xE7303E1B2336DE0E)
        testXXH3WithSeq(input[0..<24], 0, 0xA3FE70BF9D3510EB)
        testXXH3WithSeq(input[0..<24], PRIME64, 0x850E80FC35BDD690)
        testXXH3WithSeq(input[0..<48], 0, 0x397DA259ECBA1F11)
        testXXH3WithSeq(input[0..<48], PRIME64, 0xADC2CBAA44ACC616)
        testXXH3WithSeq(input[0..<80], 0, 0xBCDEFBBB2C47C90A)
        testXXH3WithSeq(input[0..<80], PRIME64, 0xC6DD0CB699532E73)
        testXXH3WithSeq(input[0..<195], 0, 0xCD94217EE362EC3A)
        testXXH3WithSeq(input[0..<195], PRIME64, 0xBA68003D370CB3D9)
        
        testXXH3WithSeq(input[0..<403], 0, 0xCDEB804D65C6DEA4)
        testXXH3WithSeq(input[0..<403], PRIME64, 0x6259F6ECFD6443FD)
        testXXH3WithSeq(input[0..<512], 0, 0x617E49599013CB6B)
        testXXH3WithSeq(input[0..<512], PRIME64, 0x3CE457DE14C27708)
        testXXH3WithSeq(input[0..<2048], 0, 0xDD59E2C3A5F038E0)
        testXXH3WithSeq(input[0..<2048], PRIME64, 0x66F81670669ABABC)
        testXXH3WithSeq(input[0..<2240], 0, 0x6E73A90539CF2948)
        testXXH3WithSeq(input[0..<2240], PRIME64, 0x757BA8487D1B5247)
        testXXH3WithSeq(input[0..<2367], 0, 0xCB37AEB9E5D361ED)
        testXXH3WithSeq(input[0..<2367], PRIME64, 0xD2DB3415B942B42A)
    }
    
    func testXXH3(_ input: String, _ seed: UInt64, _ expectResult: UInt64) {
        XCTAssertEqual(XXH3.digest64(input, seed: seed), expectResult)
        
        // streaming API test
        let digest = try! XXH3.digest64(seed: seed) { state in
            try state.update(input)
        }
        XCTAssertEqual(digest, expectResult)
    }
    
    func testXXH3WithSeq<S: Sequence>(_ input: S, _ seed: UInt64, _ expectResult: UInt64) where S.Element == UInt8 {
        XCTAssertEqual(XXH3.digest64(input, seed: seed), expectResult)
        
        // streaming API test
        let digest = try! XXH3.digest64(seed: seed) { state in
            try state.update(input)
        }
        XCTAssertEqual(digest, expectResult)
    }
    
    func testXXH3_string_sanityCheck() {
        let cases = [
            "",
            "a",
            "abc",
            "a🌍c",
            "😊😊",
            "中文english",
            String(repeating: "非常长", count: 100000),
        ]
        for string in cases {
            XCTAssertEqual(XXH3.digest64(string), XXH3.digest64(Array(string.utf8)))
        }
    }
    
    func testXXH3_data_sanityCheck() {
        let data = Data()
        XCTAssertEqual(XXH3.digest64(data), XXH3.digest64(Array<UInt8>(data)))
        
        for _ in 0..<100 {
            for data in [secureRandomData(count: 10), secureRandomData(count: 100), secureRandomData(count: 1000), secureRandomData(count: 10000)] {
//                print(data.reduce("") {$0 + String(format: "%02x", $1)})
                XCTAssertEqual(XXH3.digest64(data), XXH3.digest64(Array<UInt8>(data)))
            }
        }
    }
    
    func secureRandomData(count: Int) -> Data {
        var bytes = [Int8](repeating: 0, count: count)

        // Fill bytes with secure random data
        let status = SecRandomCopyBytes(
            kSecRandomDefault,
            count,
            &bytes
        )
        
        // A status of errSecSuccess indicates success
        if status == errSecSuccess {
            // Convert bytes to Data
            let data = Data(bytes: bytes, count: count)
            return data
        }
        else {
            fatalError("random data failed: \(status)")
        }
    }
}

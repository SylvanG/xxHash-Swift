# xxHash-Swift

[xxHash](https://cyan4973.github.io/xxHash/) framework in Swift. Original xxHash algorithm created by Yann Collet.

Currently only suppport XXH3-64. 

It currently points to the upstream [v0.8.1](https://github.com/Cyan4973/xxHash/blob/v0.8.1/CHANGELOG)


## Requirements
* Swift 5.0

## Installation
* Using [Swift Package Manager](https://www.swift.org/package-manager/)

## Usage
```Swift
import xxHash_Swift
```

### Generate one-shot digest
```Swift
let digest = XXH3.digest64("Input String")

let digest = XXH3.digest64(Data())
```

### Generate digest by streaming
1. non-async
```Swift
let digest = try XXH3.digest64 { state in
    for data in dataProducer {
        try state.update(data)
    }
}
return String(digest, radix: 16, uppercase: true)
```

2. async
```Swift
let digest = try await XXH3.digest64 { state in
    for try await data in dataProducer {
        try state.update(data)
    }
}
return String(digest, radix: 16, uppercase: true)
```

## Contribution

### Update with upstream version

1. Checkout upstream code with a new version, e.g. v0.8.2
```bash
git -C Sources/xxHash/xxHash checkout v0.8.2
```

2. Update Sources and Tests if needed
3. Update README if needed
4. Tag with a new version accoring to [Semantic Versioning 2.0.0](https://semver.org/)


### Update Swift Package Tools Version
1. Update `Package.swift` manifest, according to (Setting the Swift Tools Version
)[https://github.com/apple/swift-package-manager/blob/main/Documentation/Usage.md#setting-the-swift-tools-version]
For example, if we want to set the tools version to 5.5
```bash
swift package tools-version --set 5.5
```
2. Update `README` with Swift requirements
3. Run test


### Add more test according to upstream test data
[Test data reference](https://github.com/Cyan4973/xxHash/blob/v0.8.1/cli/xsum_sanity_check.c)

### Add more hash algorithm supported in the upstream
[Reference file](https://github.com/Cyan4973/xxHash/blob/v0.8.1/xxhash.h)


## License
The library is BSD licensed, which has the same as the [upstream](https://github.com/Cyan4973/xxHash/tree/dev#license).

# xxHash-Swift

[xxHash](https://cyan4973.github.io/xxHash/) framework in Swift.
Currently only suppport XXH3-64.

Original xxHash algorithm created by Yann Collet.


## Requirements
* Swift 5.0

## Installation
* Using [Swift Package Manager](https://www.swift.org/package-manager/)

## Usage
```Swift
import xxHash_Swift
```

### Generate one-shot digest
TODO

### Generate digest by streaming
TODO

## Update with upstream version

1. Checkout upstream code with a new version, e.g. v0.8.1
```bash
git -C Sources/xxHash/xxHash checkout v0.8.1
```

2. Update Sources and Tests if needed
3. Update README if needed
4. Tag with a new version accoring to [Semantic Versioning 2.0.0](https://semver.org/)


## License
The library is BSD licensed, which has the same as [upstream](https://github.com/Cyan4973/xxHash/tree/dev#license).

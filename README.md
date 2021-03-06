# PropertyEquatable

### Source Code

```swift
protocol PropertyEquatable {}
extension PropertyEquatable {
    // Do not use `==` because extension can NOT override methods,
    // and most NSObjects conforms to `Equatable` by implementing `==` simply compare their addresses.
    static func ~= (lhs: Self, rhs: Self) -> Bool {
        func _recursiveCompareElements(lhs: Any, rhs: Any) -> Bool {
            guard type(of: lhs) == type(of: rhs) else { return false }

            let lMir = Mirror(reflecting: lhs)
            let rMir = Mirror(reflecting: rhs)

            return lMir.children.elementsEqual(rMir.children) { (lElm, rElm) -> Bool in
                guard let lKey = lElm.label,
                    let rKey = rElm.label,
                    lKey == rKey else {
                        return false
                }

                // MARK: Collection
                // Arrays, Sets, Dictionaries are all Hashable, and can easily fall down to AnyHashable.
                // But if the Elements are MirrorEquatable, we need to compare the Elements using our methods.

                // Arrays
                if let lArr = lElm.value as? Array<PropertyEquatable>,
                    let rArr = rElm.value as? Array<PropertyEquatable> {
                    return lArr.elementsEqual(rArr) { _recursiveCompareElements(lhs: $0, rhs: $1) }
                }

                // Sets Elements must be Hashable, we don't need to consider about this case.

                // Dictionaries
                if let lDic = lElm.value as? [AnyHashable: PropertyEquatable],
                    let rDic = rElm.value as? [AnyHashable: PropertyEquatable] {
                    guard lDic.count == rDic.count else { return false }
                    for key in lDic.keys {
                        guard let lVal = lDic[key], let rVal = rDic[key] else { return false }
                        if !_recursiveCompareElements(lhs: lVal, rhs: rVal) {
                            return false
                        }
                    }
                    return true
                }

                // MARK: AnyHashable
                if let lVal = lElm.value as? AnyHashable,
                    let rVal = rElm.value as? AnyHashable {
                    return lVal == rVal
                }

                // MARK: Classes, Structs and others that do not match the conditions above
                return _recursiveCompareElements(lhs: lElm.value, rhs: rElm.value)
            }
        }

        return _recursiveCompareElements(lhs: lhs, rhs: rhs)
    }
}
```

### Sample

```swift
struct Album: PropertyEquatable {
    let id: Int
    let name: String
    let thumbnailImageUrl: String
}

struct AlbumCover: PropertyEquatable {
    let album: Album
    let numOfPhoto: Int
}

let album1 = Album(id: 0, name: "name", thumbnailImageUrl: "url")
let album2 = Album(id: 0, name: "name", thumbnailImageUrl: "url")
let album3 = Album(id: 1, name: "name", thumbnailImageUrl: "url")

print(album1 ~= album2)  // true
print(album1 ~= album3)  // false

let cover1 = AlbumCover(album: album1, numOfPhoto: 1)
let cover2 = AlbumCover(album: album1, numOfPhoto: 1)
let cover3 = AlbumCover(album: album3, numOfPhoto: 1)

print(cover1 ~= cover2)  // true
print(cover1 ~= cover3)  // false
```

# PropertyEquatable

### Source Code

```swift
protocol PropertyEquatable: Equatable {}
extension PropertyEquatable {
    static func ~= (lhs: Self, rhs: Self) -> Bool {
        func recursiveCompareElements(lhs: Any, rhs: Any) -> Bool {
            let lMir = Mirror(reflecting: lhs)
            let rMir = Mirror(reflecting: rhs)

            return lMir.children.elementsEqual(rMir.children) { (lElm, rElm) -> Bool in
                guard let lKey = lElm.label,
                    let rKey = rElm.label,
                    lKey == rKey else {
                    return false
                }

                if let lVal = lElm.value as? Array<Any>,
                    let rVal = rElm.value as? Array<Any> {
                    return lVal.elementsEqual(rVal) { recursiveCompareElements(lhs: $0, rhs: $1) }
                }

                // TODO: Set & Dictionary

                if let lVal = lElm.value as? AnyHashable,
                    let rVal = rElm.value as? AnyHashable {
                    return lVal == rVal
                }

                return recursiveCompareElements(lhs: lElm.value, rhs: rElm.value)
            }
        }

        return recursiveCompareElements(lhs: lhs, rhs: rhs)
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

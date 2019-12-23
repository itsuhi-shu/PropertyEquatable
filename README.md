# PropertyEquatable

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

print(album1 == album2)  // true
print(album1 == album3)  // false

let cover1 = AlbumCover(album: album1, numOfPhoto: 1)
let cover2 = AlbumCover(album: album1, numOfPhoto: 1)
let cover3 = AlbumCover(album: album3, numOfPhoto: 1)

print(cover1 == cover2)  // true
print(cover1 == cover3)  // false
```

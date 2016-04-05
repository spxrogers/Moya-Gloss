Moya-Gloss
============
[![CocoaPods](https://img.shields.io/cocoapods/v/Moya-Gloss.svg)](https://github.com/spxrogers/Moya-Gloss)

[Gloss](https://github.com/hkellaway/Gloss) bindings for [Moya](https://github.com/Moya/Moya) for convenient JSON serialization.
Supports [RxSwift](https://github.com/ReactiveX/RxSwift/) bindings as well.

# Installation

## CocoaPods

Add to your Podfile:
```ruby
pod 'Moya-Gloss'
```

The subspec if you want to use the bindings over RxSwift.

```ruby
pod 'Moya-Gloss/RxSwift'
```

# Usage

### Define your Model
Create a `Class` or `Struct` which implements the `Decodable` (or `Glossy`) protocol.

```swift
import Foundation
import Gloss

struct Person: Decodable {

  var name: String
  var age: Int?

  init?(json: JSON) {
    guard let name: String = "name" <~~ json
      else { return nil }
    
    self.name = name
    self.age = "age" <~~ json
  }
}
```

## 1. Without RxSwift


```swift
provider.request(API.ExampleGet) { (result) -> () in
  switch result {
    case let .Success(response):
      do {
        let person = try response.mapObject(Person)
          print("Found person: \(person)")
      } catch {
          print(error)
      }
    case let .Failure(error):
      print(error)
    }
  }
}
```

## 2. With RxSwift

```swift
provider.request(API.ExampleGet)
  .mapObject(Person)
  .subscribe { event -> Void in
    switch event {
    case .Next(let person):
      print("Found person: \(person)")
    case .Error(let error):
      print(error)
    default:
      break
    }
  }
```

# Contributing

Issues and pull requests are welcome!

# Author

Steven Rogers [@spxrogers](https://twitter.com/spxrogers)

# License

Moya-Gloss is released under an MIT license. See LICENSE for more information.


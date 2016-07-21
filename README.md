Moya-Gloss
============
[![CocoaPods](https://img.shields.io/cocoapods/v/Moya-Gloss.svg)](http://cocoapods.org/pods/Moya-Gloss)
[![Carthage
compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[Gloss](https://github.com/hkellaway/Gloss) bindings for [Moya](https://github.com/Moya/Moya) for fabulous JSON serialization.
Supports [RxSwift](https://github.com/ReactiveX/RxSwift/) and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/) bindings as well.

# Installation

### CocoaPods

Add to your Podfile:

```ruby
pod 'Moya-Gloss'
```

The subspec(s) if you want to use the bindings over RxSwift or ReactiveCocoa.

```ruby
pod 'Moya-Gloss/RxSwift'
pod 'Moya-Gloss/ReactiveCocoa'
```

### Carthage

```ruby
github "spxrogers/Moya-Gloss"
```

Carthage lists `Moya` and `Gloss` as explicit dependencies, so it's only
necessary to list the above in your Cartfile and it will pull down all
three libraries. Carthage will generate three frameworks, `MoyaGloss`,
`RxMoyaGloss`, and `ReactiveMoyaGloss` (following the naming convention of the
three generated frameworks from Moya). 

**Note: is only necessary to import one of these variations, otherwise Xcode
will give you an "Ambiguous use..." error.**

# Usage

### Define your Model

Create a `Class` or `Struct` which implements the `Decodable` (or `Glossy`) protocol.

```swift
import Foundation
import Gloss

struct Person: Decodable {

  let name: String
  let age: Int?

  init?(json: JSON) {
    guard let name: String = "name" <~~ json
      else { return nil }
    
    self.name = name
    self.age = "age" <~~ json
  }
}
```

### API

```swift
mapObject()
mapObject(forKeyPath:)
mapArray()
mapArray(forKeyPath:)
```

## 1. Example


```swift
provider.request(ExampleAPI.GetObject) { (result) in
  switch result {
  case .Success(let response):
    do {
      let person = try response.mapObject(Person)
      // *OR* the line below for a keyPath
      // let person = try response.mapObject(Person.self, forKeyPath: "person")
      print("Found person: \(person)")
    } catch {
      print(error)
    }
  case .Failure(let error):
    print(error)
  }
}
```

## 2. Example With RxSwift

```swift
provider.request(ExampleAPI.GetObject)
  .mapObject(Person)
  // *OR* the line below for a keyPath
  // .mapObject(Person.self, forKeyPath: "multi.nested.person")
  .subscribe { (event) in
    switch event {
    case .Next(let person):
      print("Found person: \(person)")
    case .Error(let error):
      print(error)
    default:
      break
    }
  }
  .addDisposableTo(your_preferred_dispose_bag)
```

## 3. Example With ReactiveCocoa

```swift
provider.request(ExampleAPI.GetObject)
  .mapObject(Person)
  // *OR* the line below for a keyPath
  // .mapObject(Person.self, forKeyPath: "person")
  .start { (event) in
    switch event {
    case .Next(let person):
      print("Found person: \(person)")
    case .Failed(let error):
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

# Thanks ... 

... to [Harlan Kellaway](http://harlankellaway.com) for creating Gloss, my preferred JSON library :)

... to the [Moya](https://github.com/Moya) team for a wonderful network library.

... and finally, to the authors of the existing Moya community extensions for inspiring me to make one for Gloss.

# License

Moya-Gloss is released under an MIT license. See LICENSE for more information.

![Chuck Norris likes a permissive
license.](http://i.giphy.com/BIuuwHRNKs15C.gif)

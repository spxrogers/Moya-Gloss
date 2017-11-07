//
//  Person.swift
//  Demo
//
//  Created by steven rogers on 4/6/16.
//  Copyright (c) 2016 Steven Rogers. All rights resereved.
//

import Foundation
import Gloss

struct Person: JSONDecodable {

  let name: String
  let age: Int?

  init?(json: JSON) {
    guard let name: String = "name" <~~ json
      else { return nil }

    self.name = name
    self.age = "age" <~~ json
  }
}

// MARK: Equatable for unit tests

extension Person: Equatable { }
func ==(lhs: Person, rhs: Person) -> Bool {
  return lhs.name == rhs.name && lhs.age == rhs.age
}

//
//  Response+Gloss.swift
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers
//

import Foundation
import Moya
import Gloss

public extension Response {

  /// Maps response data into a model object implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapObject<T: Decodable>(type: T.Type) throws -> T {
    guard
      let json = try mapJSON() as? JSON,
      let result = T(json: json)
    else {
      throw Error.JSONMapping(self)
    }
    return result
  }

  /// Maps the response data into an array of model objects implementing the Decodable protocol.
  /// Throws a JSONMapping error on failure.
  public func mapArray<T: Decodable>(type: T.Type) throws -> [T] {
    guard
      let json = try mapJSON() as? [JSON]
    else {
      throw Error.JSONMapping(self)
    }
    return [T].fromJSONArray(json)
  }

}

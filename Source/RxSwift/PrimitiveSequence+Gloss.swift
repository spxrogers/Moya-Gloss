//
//  PrimitiveSequence+Gloss.swift
//  MoyaGloss
//
//  Created by steven rogers on 11/6/17.
//

import RxSwift
import Moya
import Gloss

/// Extension for transforming Moya Responses into Decodable object(s) via Gloss with Rx goodness
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

  /// Maps response data into an Single of a type that implements the Decodable protocol.
  /// Single .Errors's on failure.
  public func mapObject<T: JSONDecodable>(type: T.Type) -> Single<T> {
    return flatMap { response -> Single<T> in
      return Single.just(try response.mapObject(T.self))
    }
  }

  /// Maps nested response data into an Single of a type that implements the Decodable protocol.
  /// Single .Errors's on failure.
  public func mapObject<T: JSONDecodable>(type: T.Type, forKeyPath keyPath: String) -> Single<T> {
    return flatMap { response -> Single<T> in
      return Single.just(try response.mapObject(T.self, forKeyPath: keyPath))
    }
  }

  /// Maps response data into an Single of an array of a type that implements the Decodable protocol.
  /// Single .Errors's on failure.
  public func mapArray<T: JSONDecodable>(type: T.Type) -> Single<[T]> {
    return flatMap { (response) -> Single<[T]> in
      return Single.just(try response.mapArray(T.self))
    }
  }

  /// Maps nested response data into an Single of an array of a type that implements the Decodable protocol.
  /// Single .Errors's on failure.
  public func mapArray<T: JSONDecodable>(type: T.Type, forKeyPath keyPath: String) -> Single<[T]> {
    return flatMap { (response) -> Single<[T]> in
      return Single.just(try response.mapArray(T.self, forKeyPath: keyPath))
    }
  }
}

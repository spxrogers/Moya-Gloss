//
//  Observable+Gloss.swift
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers
//

import Foundation
import RxSwift
import Moya
import Gloss
import MoyaGloss

/// Extension for transforming Responses into Decodable object via Gloss
public extension ObservableType where E == Response {

  /// Maps response data into an Observable of a type that implements the Decodable protocol.
  /// Observable .Errors's on failure.
  public func mapObject<T: Decodable>(type: T.Type) -> Observable<T> {
    return flatMap { response -> Observable<T> in
      return Observable.just(try response.mapObject(T))
    }
  }

  /// Maps response data into an Observable of an array of a type that implements the Decodable protocol.
  /// Observable .Errors's on failure.
  public func mapArray<T: Decodable>(type: T.Type) -> Observable<[T]> {
    return flatMap { (response) -> Observable<[T]> in
      return Observable.just(try response.mapArray(T))
    }
  }

}

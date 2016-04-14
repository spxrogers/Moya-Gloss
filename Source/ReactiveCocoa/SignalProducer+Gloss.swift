//
//  SignalProducer+Gloss.swift
//
//  Created by steven rogers on 4/14/16.
//  Copyright (c) 2016 Steven Rogers
//

import Foundation
import ReactiveCocoa
import Moya
import Gloss

extension SignalProducerType where Value == Moya.Response, Error == Moya.Error {

  /// Maps data received from the signal into a model object implementing the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapObject<T: Decodable>(type: T.Type) -> SignalProducer<T, Error> {
    return producer.flatMap(.Latest) { response -> SignalProducer<T, Error> in
      return unwrapThrowable { try response.mapObject(T) }
    }
  }

  /// Maps data received from the signal into an array of a type that implements the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapArray<T: Decodable>(type: T.Type) -> SignalProducer<[T], Error> {
    return producer.flatMap(.Latest) { response -> SignalProducer<[T], Error> in
      return unwrapThrowable { try response.mapArray(T) }
    }
  }
}

/// Maps throwable to SignalProducer
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, Moya.Error> {
  do {
    return SignalProducer(value: try throwable())
  } catch {
    return SignalProducer(error: error as! Moya.Error)
  }
}

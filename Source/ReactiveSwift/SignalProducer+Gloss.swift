//
//  SignalProducer+Gloss.swift
//
//  Created by steven rogers on 4/14/16.
//  Copyright (c) 2016 Steven Rogers
//

import ReactiveSwift
import Moya
import Gloss

/// Extension for transforming Moya Responses into Decodable object(s) via Gloss with RAC goodness
public extension SignalProducerProtocol where Value == Moya.Response, Error == Moya.MoyaError {

  /// Maps data received from the signal into a model object implementing the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapObject<T: Decodable>(type: T.Type) -> SignalProducer<T, Error> {
    return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
      return unwrapThrowable { try response.mapObject(T.self) }
    }
  }
  
  /// Maps nested data received from the signal into a model object implementing the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapObject<T: Decodable>(type: T.Type, forKeyPath keyPath: String) -> SignalProducer<T, Error> {
    return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
      return unwrapThrowable { try response.mapObject(T.self, forKeyPath: keyPath) }
    }
  }

  /// Maps data received from the signal into an array of a type that implements the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapArray<T: Decodable>(type: T.Type) -> SignalProducer<[T], Error> {
    return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
      return unwrapThrowable { try response.mapArray(T.self) }
    }
  }
  
  /// Maps nested data received from the signal into an array of a type that implements the Decodable protocol.
  /// The signal errors on conversion failure.
  public func mapArray<T: Decodable>(type: T.Type, forKeyPath keyPath: String) -> SignalProducer<[T], Error> {
    return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
      return unwrapThrowable { try response.mapArray(T.self, forKeyPath: keyPath) }
    }
  }
}

/// Maps throwable to SignalProducer
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, MoyaError> {
  do {
    return SignalProducer(value: try throwable())
  } catch {
    return SignalProducer(error: error as! MoyaError)
  }
}

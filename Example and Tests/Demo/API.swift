//
//  API.swift
//  Demo
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers. All rights resereved.
//

import Foundation
import Moya

let stubbedProvider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
let rxStubbedProvider = RxMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
let racStubbedProvider = ReactiveCocoaMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)

enum ExampleAPI {
  case GetObject
  case GetArray
  case GetBadObject
  case GetBadFormat
}

extension ExampleAPI: TargetType {
  var baseURL: NSURL { return NSURL(string: "http://srogers.net/rest")! }

  var path: String {
    switch self {
    case .GetObject:
      return "/person"
    case .GetArray:
      return "/people"
    case .GetBadObject:
      return "/badobject"
    case .GetBadFormat:
      return "/badformat"
    }
  }

  var method: Moya.Method {
    return .GET
  }

  var parameters: [String: AnyObject]? {
    return nil
  }

  var sampleData: NSData {
    switch self {
    case .GetObject:
      return stubbedResponse("person")
    case .GetArray:
      return stubbedResponse("people")
    case .GetBadObject:
      return stubbedResponse("bad_person")
    case .GetBadFormat:
      return stubbedResponse("bad_format")
    }
  }
}

func stubbedResponse(filename: String) -> NSData! {
  let bundle = NSBundle.mainBundle()
  let path = bundle.pathForResource(filename, ofType: "json")
  return NSData(contentsOfFile: path!)
}

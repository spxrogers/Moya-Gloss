//
//  API.swift
//  Demo
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers. All rights resereved.
//

import Foundation
import Moya

let stubbedProvider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.immediatelyStub)
let rxStubbedProvider = stubbedProvider.rx
let racStubbedProvider = stubbedProvider.reactive

enum ExampleAPI {
  case getObject
  case getArray
  case getNestedObject
  case getNestedArray
  case getBadObject
  case getBadFormat
}

extension ExampleAPI: TargetType {

  var headers: [String : String]? { return nil }

  var baseURL: URL { return URL(string: "http://srogers.net/rest")! }

  var path: String {
    switch self {
    case .getObject:
      return "/person"
    case .getArray:
      return "/people"
    case .getNestedObject:
      return "/nested_person"
    case .getNestedArray:
      return "/nested_people"
    case .getBadObject:
      return "/badobject"
    case .getBadFormat:
      return "/badformat"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var parameters: [String: Any]? {
    return nil
  }

  var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  var sampleData: Data {
    switch self {
    case .getObject:
      return stubbedResponse("person")
    case .getArray:
      return stubbedResponse("people")
    case .getNestedObject:
      return stubbedResponse("nested_person")
    case .getNestedArray:
      return stubbedResponse("nested_people")
    case .getBadObject:
      return stubbedResponse("bad_person")
    case .getBadFormat:
      return stubbedResponse("bad_format")
    }
  }

  var multipartBody: [MultipartFormData]? {
    return nil
  }
  
  var task: Task {
    return .requestPlain
  }
}

func stubbedResponse(_ filename: String) -> Data! {
  let bundle = Bundle.main
  let path = bundle.path(forResource: filename, ofType: "json")
  return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

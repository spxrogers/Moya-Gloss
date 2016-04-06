//
//  ObservableTests.swift
//  Demo
//
//  Created by steven rogers on 4/6/16.
//  Copyright (c) 2016 Steven Rogers. All rights resereved.
//

@testable import Demo
import Quick
import Nimble
import Moya
import RxSwift
import Moya_Gloss

class ObservableGlossSpec: QuickSpec {
  override func spec() {
    let getObject = ExampleAPI.GetObject
    let getArray = ExampleAPI.GetArray
    let getBadObject = ExampleAPI.GetBadObject
    let getBadFormat = ExampleAPI.GetBadFormat
    let disposeBag = DisposeBag()

    var provider: RxMoyaProvider<ExampleAPI>!
    beforeEach {
      provider = RxMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
    }

    it("handles a core object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getObject)
          .mapObject(Person)
          .subscribe { (event) in
            switch event {
            case .Next(let person):
              equal = steven == person
            case .Error(_):
              equal = false
            case .Completed:
              done()
            }
          }
          .addDisposableTo(disposeBag)
      }
      expect(equal).to(beTruthy())
    }

    it("handles a core array request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      let john = Person(json: ["name": "john doe"])!
      let people = [steven, john]
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getArray)
          .mapArray(Person)
          .subscribe{ (event) in
            switch event {
            case .Next(let resultPeople):
              equal = people == resultPeople
            case .Error(_):
              equal = false
            case .Completed:
              done()
            }
          }
          .addDisposableTo(disposeBag)
      }
      expect(equal).to(beTruthy())
    }

    it("handles a core object missing required gloss fields") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadObject)
          .mapObject(Person)
          .subscribe{ (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Error(_):
              failedWhenExpected = true
              done()
            case .Completed:
              done()
            }
          }
          .addDisposableTo(disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core object invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapObject(Person)
          .subscribe{ (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Error(_):
              failedWhenExpected = true
              done()
            case .Completed:
              done()
            }
          }
          .addDisposableTo(disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core array invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapArray(Person)
          .subscribe{ (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Error(_):
              failedWhenExpected = true
              done()
            case .Completed:
              done()
            }
          }
          .addDisposableTo(disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}

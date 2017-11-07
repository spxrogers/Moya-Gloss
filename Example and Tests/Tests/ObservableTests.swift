
@testable import Demo
import Quick
import Nimble
import Moya
import RxSwift
import Moya_Gloss

class ObservableGlossSpec: QuickSpec {
  override func spec() {
    let getObject = ExampleAPI.getObject
    let getArray = ExampleAPI.getArray
    let getNestedObject = ExampleAPI.getNestedObject
    let getNestedArray = ExampleAPI.getNestedArray
    let getBadObject = ExampleAPI.getBadObject
    let getBadFormat = ExampleAPI.getBadFormat
    let disposeBag = DisposeBag()

    let steven = Person(json: ["name": "steven rogers", "age": 23])!
    let john = Person(json: ["name": "john doe"])!
    let people = [steven, john]

    var provider: Reactive<MoyaProvider<ExampleAPI>>!
    beforeEach {
      provider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.immediatelyStub).rx
    }

    // standard
    it("handles a core object request") {
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getObject)
          .mapObject(type: Person.self)
          .subscribe { (event) in
            switch event {
            case .success(let person):
              equal = steven == person
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }

    it("handles a core array request") {
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getArray)
          .mapArray(type: Person.self)
          .subscribe{ (event) in
            switch event {
            case .success(let resultPeople):
              equal = people == resultPeople
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }

    // nested object
    it("handles a core nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "person")
          .subscribe { (event) in
            switch event {
            case .success(let person):
              equal = steven == person
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "multi.nested.person")
          .subscribe { (event) in
            switch event {
            case .success(let person):
              equal = steven == person
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }
    
    // nested array
    it("handles a core nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "people")
          .subscribe{ (event) in
            switch event {
            case .success(let resultPeople):
              equal = people == resultPeople
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "multi.nested.people")
          .subscribe{ (event) in
            switch event {
            case .success(let resultPeople):
              equal = people == resultPeople
              done()
            case .error(_):
              equal = false
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(equal).to(beTruthy())
    }
    
    // bad requests
    it("handles a core object missing required gloss fields") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadObject)
          .mapObject(type: Person.self)
          .subscribe{ (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core object invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapObject(type: Person.self)
          .subscribe{ (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core array invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapArray(type: Person.self)
          .subscribe{ (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "doesnotexist")
          .subscribe { (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "multi.whoops")
          .subscribe { (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "doesnotexist")
          .subscribe { (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapObject(type: Person.self, forKeyPath: "multi.whoops")
          .subscribe { (event) in
            switch event {
            case .success(_):
              failedWhenExpected = false
              done()
            case .error(_):
              failedWhenExpected = true
              done()
            }
          }
          .disposed(by: disposeBag)
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}

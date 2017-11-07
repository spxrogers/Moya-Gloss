
@testable import Demo
import Quick
import Nimble
import Moya
import ReactiveSwift
import Moya_Gloss

class SignalProducerGlossSpec: QuickSpec {
  override func spec() {
    let getObject = ExampleAPI.getObject
    let getArray = ExampleAPI.getArray
    let getNestedObject = ExampleAPI.getNestedObject
    let getNestedArray = ExampleAPI.getNestedArray
    let getBadObject = ExampleAPI.getBadObject
    let getBadFormat = ExampleAPI.getBadFormat

    let steven = Person(json: ["name": "steven rogers", "age": 23])!
    let john = Person(json: ["name": "john doe"])!
    let people = [steven, john]

    var provider: Reactive<MoyaProvider<ExampleAPI>>!
    beforeEach {
      provider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.immediatelyStub).reactive
    }

    // standard
    it("handles a core object request") {
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getObject)
          .mapObject(type: Person.self)
          .start { (event) in
            switch event {
            case .value(let person):
              equal = steven == person
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }

    it("handles a core array request") {
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getArray)
          .mapArray(type: Person.self)
          .start { (event) in
            switch event {
            case .value(let resultPeople):
              equal = people == resultPeople
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
          }
      }
      expect(equal).to(beTruthy())
    }

    // nested object
    it("handles a core nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "person")
          .start { (event) in
            switch event {
            case .value(let person):
              equal = steven == person
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "multi.nested.person")
          .start { (event) in
            switch event {
            case .value(let person):
              equal = steven == person
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    // nested array 
    it("handles a core nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "people")
          .start { (event) in
            switch event {
            case .value(let resultPeople):
              equal = people == resultPeople
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "multi.nested.people")
          .start { (event) in
            switch event {
            case .value(let resultPeople):
              equal = people == resultPeople
            case .failed(_):
              equal = false
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    // bad requests
    it("handles a core object missing required gloss fields") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadObject)
          .mapObject(type: Person.self)
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            default:
              done()
            }
          }
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core object invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapObject(type: Person.self)
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            default:
              done()
            }
          }

      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core array invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat)
          .mapArray(type: Person.self)
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            default:
              done()
            }
          }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "doesnotexist")
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(type: Person.self, forKeyPath: "multi.whoops")
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "doesnotexist")
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(type: Person.self, forKeyPath: "multi.whoops")
          .start { (event) in
            switch event {
            case .value(_):
              failedWhenExpected = false
            case .failed(_):
              failedWhenExpected = true
              done()
            case .completed:
              done()
            default:
              break
            }
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}

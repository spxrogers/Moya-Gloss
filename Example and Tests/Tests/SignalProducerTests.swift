
@testable import Demo
import Quick
import Nimble
import Moya
import ReactiveCocoa
import Moya_Gloss

class SignalProducerGlossSpec: QuickSpec {
  override func spec() {
    let getObject = ExampleAPI.GetObject
    let getArray = ExampleAPI.GetArray
    let getNestedObject = ExampleAPI.GetNestedObject
    let getNestedArray = ExampleAPI.GetNestedArray
    let getBadObject = ExampleAPI.GetBadObject
    let getBadFormat = ExampleAPI.GetBadFormat

    var provider: ReactiveCocoaMoyaProvider<ExampleAPI>!
    beforeEach { 
      provider = ReactiveCocoaMoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
    }

    // standard
    it("handles a core object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getObject)
          .mapObject(Person)
          .start { (event) in
            switch event {
            case .Next(let person):
              equal = steven == person
            case .Failed(_):
              equal = false
            case .Completed:
              done()
            default:
              break
            }
        }
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
          .start { (event) in
            switch event {
            case .Next(let resultPeople):
              equal = people == resultPeople
            case .Failed(_):
              equal = false
            case .Completed:
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
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(Person.self, forKeyPath: "person")
          .start { (event) in
            switch event {
            case .Next(let person):
              equal = steven == person
            case .Failed(_):
              equal = false
            case .Completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject)
          .mapObject(Person.self, forKeyPath: "multi.nested.person")
          .start { (event) in
            switch event {
            case .Next(let person):
              equal = steven == person
            case .Failed(_):
              equal = false
            case .Completed:
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
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      let john = Person(json: ["name": "john doe"])!
      let people = [steven, john]
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(Person.self, forKeyPath: "people")
          .start { (event) in
            switch event {
            case .Next(let resultPeople):
              equal = people == resultPeople
            case .Failed(_):
              equal = false
            case .Completed:
              done()
            default:
              break
            }
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      let john = Person(json: ["name": "john doe"])!
      let people = [steven, john]
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray)
          .mapArray(Person.self, forKeyPath: "multi.nested.people")
          .start { (event) in
            switch event {
            case .Next(let resultPeople):
              equal = people == resultPeople
            case .Failed(_):
              equal = false
            case .Completed:
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
          .mapObject(Person)
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
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
          .mapObject(Person)
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
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
          .mapArray(Person)
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
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
          .mapObject(Person.self, forKeyPath: "doesnotexist")
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
              failedWhenExpected = true
              done()
            case .Completed:
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
          .mapObject(Person.self, forKeyPath: "multi.whoops")
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
              failedWhenExpected = true
              done()
            case .Completed:
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
          .mapArray(Person.self, forKeyPath: "doesnotexist")
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
              failedWhenExpected = true
              done()
            case .Completed:
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
          .mapArray(Person.self, forKeyPath: "multi.whoops")
          .start { (event) in
            switch event {
            case .Next(_):
              failedWhenExpected = false
            case .Failed(_):
              failedWhenExpected = true
              done()
            case .Completed:
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


@testable import Demo
import Quick
import Nimble
import Moya
import Moya_Gloss

class ResponseGlossSpec: QuickSpec {
  override func spec() {
    let getObject = ExampleAPI.GetObject
    let getArray = ExampleAPI.GetArray
    let getNestedObject = ExampleAPI.GetNestedObject
    let getNestedArray = ExampleAPI.GetNestedArray
    let getBadObject = ExampleAPI.GetBadObject
    let getBadFormat = ExampleAPI.GetBadFormat

    var provider: MoyaProvider<ExampleAPI>!
    beforeEach {
      provider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.ImmediatelyStub)
    }

    // standard
    it("handles a core object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              let person = try response.mapObject(Person)
              equal = steven == person
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
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
        provider.request(getArray) { (result) in
          switch result {
          case .Success(let response):
            do {
              let resultPeople = try response.mapArray(Person)
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }

    // nested object
    it("handles a core nested-object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              let person = try response.mapObject(Person.self, forKeyPath: "person")
              equal = steven == person
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              let person = try response.mapObject(Person.self, forKeyPath: "multi.nested.person")
              equal = steven == person
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
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
        provider.request(getNestedArray) { (result) in
          switch result {
          case .Success(let response):
            do {
              let resultPeople = try response.mapArray(Person.self, forKeyPath: "people")
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-nested nested-array request") {
      let steven = Person(json: ["name": "steven rogers", "age": 21])!
      let john = Person(json: ["name": "john doe"])!
      let people = [steven, john]
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray) { (result) in
          switch result {
          case .Success(let response):
            do {
              let resultPeople = try response.mapArray(Person.self, forKeyPath: "multi.nested.people")
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .Failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    // bad requests
    it("handles a core object missing required gloss fields") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapArray(Person)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
        }
        done()
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core object invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapObject(Person)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
        }
        done()
      }
      expect(failedWhenExpected).to(beTruthy())
    }

    it("handles a core array invalid format") {
      var failedWhenExpected = false

      waitUntil(timeout: 5) { done in
        provider.request(getBadFormat) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapArray(Person)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
        }
        done()
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapObject(Person.self, forKeyPath: "doesnotexist")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapObject(Person.self, forKeyPath: "multi.whoops")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapArray(Person.self, forKeyPath: "doesnotexist")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
    
    it("handles a core multi-level nested-array request with invalid keyPath") {
      var failedWhenExpected = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray) { (result) in
          switch result {
          case .Success(let response):
            do {
              _ = try response.mapArray(Person.self, forKeyPath: "multi.whoops")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .Failure(_):
            failedWhenExpected = false
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}

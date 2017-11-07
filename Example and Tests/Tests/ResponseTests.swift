
@testable import Demo
import Quick
import Nimble
import Moya
import Moya_Gloss

class ResponseGlossSpec: QuickSpec {
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

    var provider: MoyaProvider<ExampleAPI>!
    beforeEach {
      provider = MoyaProvider<ExampleAPI>(stubClosure: MoyaProvider.immediatelyStub)
    }

    // standard
    it("handles a core object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getObject) { (result) in
          switch result {
          case .success(let response):
            do {
              let person = try response.mapObject(Person.self)
              equal = steven == person
            } catch {
              equal = false
            }
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }

    it("handles a core array request") {
      var equal = false

      waitUntil(timeout: 5) { done in
        provider.request(getArray) { (result) in
          switch result {
          case .success(let response):
            do {
              let resultPeople = try response.mapArray(Person.self)
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }

    // nested object
    it("handles a core nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .success(let response):
            do {
              let person = try response.mapObject(Person.self, forKeyPath: "person")
              equal = steven == person
            } catch {
              equal = false
            }
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-level nested-object request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedObject) { (result) in
          switch result {
          case .success(let response):
            do {
              let person = try response.mapObject(Person.self, forKeyPath: "multi.nested.person")
              equal = steven == person
            } catch {
              equal = false
            }
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    // nested array
    it("handles a core nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray) { (result) in
          switch result {
          case .success(let response):
            do {
              let resultPeople = try response.mapArray(Person.self, forKeyPath: "people")
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .failure(_):
            equal = false
          }
          done()
        }
      }
      expect(equal).to(beTruthy())
    }
    
    it("handles a core multi-nested nested-array request") {
      var equal = false
      
      waitUntil(timeout: 5) { done in
        provider.request(getNestedArray) { (result) in
          switch result {
          case .success(let response):
            do {
              let resultPeople = try response.mapArray(Person.self, forKeyPath: "multi.nested.people")
              equal = people == resultPeople
            } catch {
              equal = false
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapArray(Person.self)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapObject(Person.self)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapArray(Person.self)
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapObject(Person.self, forKeyPath: "doesnotexist")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapObject(Person.self, forKeyPath: "multi.whoops")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapArray(Person.self, forKeyPath: "doesnotexist")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
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
          case .success(let response):
            do {
              _ = try response.mapArray(Person.self, forKeyPath: "multi.whoops")
              failedWhenExpected = false
            } catch {
              failedWhenExpected = true
            }
          case .failure(_):
            failedWhenExpected = false
          }
          done()
        }
      }
      expect(failedWhenExpected).to(beTruthy())
    }
  }
}

//
//  ViewController.swift
//  Demo
//
//  Created by steven rogers on 4/5/16.
//  Copyright (c) 2016 Steven Rogers. All rights resereved.
//

import UIKit
import Foundation
import RxSwift
import ReactiveSwift
import Moya_Gloss

class ViewController: UIViewController {

  @IBOutlet var resultsLabel: UILabel!

  let object = ExampleAPI.getObject
  let array = ExampleAPI.getArray
  let disposeBag = DisposeBag()

  fileprivate func text(_ text: String) {
    resultsLabel.text = text
  }

  // MARK: - Plain Moya Examples

  @IBAction func mapPersonPressed(_ sender: UIButton) {
    stubbedProvider.request(object) { (result) in
      switch result {
      case .success(let response):
        do {
          let person = try response.mapObject(Person.self)
          self.text("Found person: \(person)")
        } catch {
          self.text("Error mapping object")
        }
      case .failure(let err):
        self.text("Failure: \(err)")
      }
    }
  }

  @IBAction func mapPeoplePressed(_ sender: UIButton) {
    stubbedProvider.request(array) { (result) in
      switch result {
      case .success(let response):
        do {
          let people = try response.mapArray(Person.self)
          self.text("Found people: \(people)")
        } catch {
          self.text("Error mapping array")
        }
      case .failure(let err):
        self.text("Failure: \(err)")
      }
    }
  }

  // MARK: - Moya with RxSwift Example

  @IBAction func rxMapPersonPressed(_ sender: UIButton) {
    rxStubbedProvider.request(object)
      .mapObject(type: Person.self)
      .subscribe { (event) in
      switch event {
      case .success(let person):
        self.text("Found person: \(person)")
      case .error(let err):
        self.text("Failure: \(err)")
      }
    }
    .disposed(by: disposeBag)
  }

  @IBAction func rxMapPeoplePressed(_ sender: UIButton) {
    rxStubbedProvider.request(array)
      .mapArray(type: Person.self)
      .subscribe { (event) in
        switch event {
        case .success(let people):
          self.text("Found people: \(people)")
        case .error(let err):
          self.text("Failure: \(err)")
        }
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Moya with ReactiveCocoa Example

  @IBAction func racMapPerson(_ sender: UIButton) {
    racStubbedProvider.request(object)
      .mapObject(type: Person.self)
      .start { (event) in
        switch event {
        case .value(let person):
          self.text("Found person: \(person)")
        case .failed(let err):
          self.text("Failure: \(err)")
        default:
          break
        }
      }
  }

  @IBAction func racMapPeople(_ sender: UIButton) {
    racStubbedProvider.request(array)
      .mapArray(type: Person.self)
      .start { (event) in
        switch event {
        case .value(let people):
          self.text("Found people: \(people)")
        case .failed(let err):
          self.text("Failure: \(err)")
        default:
          break
        }
      }
  }

}

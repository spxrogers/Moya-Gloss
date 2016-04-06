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
import Moya_Gloss

class ViewController: UIViewController {

  @IBOutlet var resultsLabel: UILabel!

  let object = ExampleAPI.GetObject
  let array = ExampleAPI.GetArray
  let disposeBag = DisposeBag()

  private func text(text: String) {
    resultsLabel.text = text
  }

  // MARK: - Plain Moya Examples

  @IBAction func mapPersonPressed(sender: UIButton) {
    stubbedProvider.request(object) { (result) in
      switch result {
      case .Success(let response):
        do {
          let person = try response.mapObject(Person)
          self.text("Found person: \(person)")
        } catch {
          self.text("Error mapping object")
        }
      case .Failure(let err):
        self.text("Failure: \(err)")
      }
    }
  }

  @IBAction func mapPeoplePressed(sender: UIButton) {
    stubbedProvider.request(array) { (result) in
      switch result {
      case .Success(let response):
        do {
          let people = try response.mapArray(Person)
          self.text("Found people: \(people)")
        } catch {
          self.text("Error mapping array")
        }
      case .Failure(let err):
        self.text("Failure: \(err)")
      }
    }
  }

  // MARK: - Moya with RxSwift Example

  @IBAction func rxMapPersonPressed(sender: UIButton) {
    rxStubbedProvider.request(object)
      .mapObject(Person)
      .subscribe { (event) in
        switch event {
        case .Next(let person):
          self.text("Found person: \(person)")
        case .Error(let err):
          self.text("Failure: \(err)")
        default:
          break
        }
      }
      .addDisposableTo(disposeBag)
  }

  @IBAction func rxMapPeoplePressed(sender: UIButton) {
    rxStubbedProvider.request(array)
      .mapArray(Person)
      .subscribe { (event) in
        switch event {
        case .Next(let people):
          self.text("Found people: \(people)")
        case .Error(let err):
          self.text("Failure: \(err)")
        default:
          break
        }
      }
      .addDisposableTo(disposeBag)
  }

}


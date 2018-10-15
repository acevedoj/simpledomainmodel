//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    let fromCurr = self.currency;
    var newAmountDouble: Double = Double(self.amount)
    var newAmountInt:Int =  Int(0);
    
    if (fromCurr == "USD") {
        if (to == "GBP") {
            return Money(amount: self.amount / 2, currency: "GBP")
        } else if (to == "CAN") {
            newAmountDouble = Double(self.amount) * 1.25
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "CAN")
        } else if (to == "EUR") {
            newAmountDouble = Double(self.amount) * 1.5
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "EUR")
        } else {
            return self;
        }
    } else if (fromCurr == "GBP") {
        if (to == "USD") {
            return Money(amount: self.amount * 2, currency: "USD")
        } else if (to == "CAN") {
            newAmountDouble = Double(self.amount) * 2.5
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "CAN")
        } else if (to == "EUR") {
            return Money(amount: self.amount * 3, currency: "EUR")
        } else {
            return self;
        }
    } else if (fromCurr == "CAN") {
        if (to == "USD") {
            newAmountDouble = Double(self.amount) / 1.25
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "USD")
        } else if (to == "GBP") {
            newAmountDouble = Double(self.amount) / 2.5
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "USD")
        } else if (to == "EUR") {
            newAmountDouble = Double(self.amount) / 0.83333333
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "EUR")
        } else {
            return self;
        }
    } else if (fromCurr == "EUR"){
        if (to == "USD") {
            newAmountDouble = Double(self.amount) / 1.5
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "USD")
        } else if (to == "GBP") {
            return Money(amount: self.amount / 3, currency: "GBP")
        } else if (to == "CAN") {
            newAmountDouble = Double(self.amount) * 0.83333333
            newAmountInt = Int(newAmountDouble)
            return Money(amount: newAmountInt, currency: "CAN")
        } else {
            return self;
        }
    }
    print("Currency is not valid, failed to convert!")
    return self;
  }
  
  public func add(_ to: Money) -> Money {
    let money = self.convert(to.currency)
    return Money(amount: to.amount + money.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let money = from.convert(self.currency)
    return Money(amount: money.amount - self.amount, currency: self.currency)
  }
}

////////////////////////////////////
// Job
//

open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title;
    self.type = type;
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let amount):
        let hoursDouble: Double = Double(amount) * Double(hours);
        let hoursInt: Int = Int(hoursDouble);
        return hoursInt
    case .Salary(let amount):
        return amount;
    }
  }
  
  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(var amount):
        amount = (amount + amt)
        type = JobType.Hourly(amount)
    case .Salary(let amount):
        let salaryDouble: Double = Double(amount) + amt
        let salaryInt: Int = Int(salaryDouble)
        type = JobType.Salary(salaryInt)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if (self.age >= 16) {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if (self.age >= 21) {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    let opening = "[Person: ";
    let firstName = "firstName:\(self.firstName) ";
    let lastName = "lastName:\(self.lastName) ";
    let age = "age:\(self.age) ";
    let job = "job:\(String(describing: self._job?.title)) ";
    let spouse = "spouse:\(String(describing: self._spouse))]"
    print(opening + firstName + lastName + age + job + spouse);
    return opening + firstName + lastName + age + job + spouse;
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1._spouse == nil && spouse2._spouse == nil) {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if ((members[0]._spouse?.age)! >= 21 || (members[1]._spouse?.age)! >= 21) {
        members.append(child)
        return true;
    }
    return false;
  }
  
  open func householdIncome() -> Int {
    var totalIncome: Int = 0
    for person in members {
        if (person._job != nil) {
            totalIncome += (person._job?.calculateIncome(2000))!
        }
    }
    return totalIncome
  }
}

import UIKit
import RxSwift

let disposeBag = DisposeBag()

//Ignore filtering operator -> kada nas nije briga za elemente, ali trebamo znati kada je sekvenca zavrsena
let ignoreStrikes = PublishSubject<String>()
ignoreStrikes
    .ignoreElements()
    .subscribe { _ in
        print("Subscription is called.")
    }
    .disposed(by: disposeBag)

ignoreStrikes.onNext("A")
ignoreStrikes.onNext("B")
ignoreStrikes.onNext("C")
ignoreStrikes.onCompleted()
print("--------------------")

//ElementAt - dohvaca element na odredenoj poziciji
let elementAtStrikes = PublishSubject<String>()
elementAtStrikes
    .elementAt(2)
    .subscribe(onNext: { _ in
        print("You are out!")
    }).disposed(by: disposeBag)

elementAtStrikes.onNext("X")
elementAtStrikes.onNext("X")
elementAtStrikes.onNext("X")
print("--------------------")

//Filter
Observable.of(1,2,3,4,5,6,7)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")


//Skip
Observable.of("A", "B", "C", "D", "E", "F")
    .skip(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//Skip while
Observable.of(2,2,3,4,4)
    .skipWhile { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//Skip until
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
    .skipUntil(trigger)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")

trigger.onNext("X")

subject.onNext("C")
print("--------------------")

//Take
Observable.of(1,2,3,4,5,6)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//Take while
Observable.of(2,4,6,7,8,10)
    .takeWhile { return $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//Take until
let subject1 = PublishSubject<String>()
let trigger1 = PublishSubject<String>()

subject1
    .takeUntil(trigger1)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

subject1.onNext("1")
subject1.onNext("2")

trigger1.onNext("X")

subject1.onNext("3")

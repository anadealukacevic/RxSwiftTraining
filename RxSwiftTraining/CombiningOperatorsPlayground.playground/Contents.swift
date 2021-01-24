import UIKit
import RxSwift

let disposeBag = DisposeBag()

//STARTS WITH
let numbers = Observable.of(2,3,4)
let observable = numbers.startWith(1)
observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


//CONCAT
let first = Observable.of(1,2,3)
let second = Observable.of(4,5,6)

let concated = Observable.concat([first, second])
concated
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


//MERGE
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()

let source = Observable.of(left.asObservable(), right.asObservable())
let merged = source.merge()
merged
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

left.onNext(10)
right.onNext(99)
left.onNext(11)
left.onNext(12)
right.onNext(98)


//COMBINE LATEST
let left1 = PublishSubject<Int>()
let right1 = PublishSubject<Int>()

let combined = Observable.combineLatest(left1, right1, resultSelector: { lastLeft, lastRight in
    "\(lastLeft) \(lastRight)"
})

let disposable = combined
    .subscribe(onNext: { value in
    print(value)
})

left1.onNext(45)
right1.onNext(1)
left1.onNext(30)
right1.onNext(1)
right1.onNext(2)


//WITH LATEST FROM
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observablee = button.withLatestFrom(textField)
let disposablee = observablee.subscribe(onNext: {
    print($0)
})

textField.onNext("SW")
textField.onNext("SWIF")
textField.onNext("SWIFT")

button.onNext(())
button.onNext(())


//REDUCE
let source1 = Observable.of(1,2,3)
source1
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
    print($0)
    }).disposed(by: disposeBag)
//different way
source1
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    }).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


//SCAN
let source2 = Observable.of(1,2,3,5,6)
source2
    .scan(0, accumulator: +)
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

//TO ARRAY
Observable.of(1,2,3,4,5)
    .toArray()
    .subscribe(onNext: {
    print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//MAP
Observable.of(1,2,3,4,5)
    .map { return $0 * 2 }
    .subscribe(onNext: {
            print($0)
    })
    .disposed(by: disposeBag)
print("--------------------")

//FLAT MAP - cijelo vrijeme prati promjene od svih
struct Student {
    var score: BehaviorRelay<Int>
}

let john = Student(score: BehaviorRelay(value: 75))
let mary = Student(score: BehaviorRelay(value: 95))

let student = PublishSubject<Student>()
student
    .asObservable()
    .flatMap { $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

student.onNext(john)
john.score.accept(34)
student.onNext(mary)
mary.score.accept(100)
john.score.accept(10)
print("--------------------")

//FLAT MAP LATEST
struct Student1 {
    var score: BehaviorRelay<Int>
}

let greg = Student1(score: BehaviorRelay(value: 75))
let ana = Student1(score: BehaviorRelay(value: 95))

let student1 = PublishSubject<Student1>()
student1
    .asObservable()
    .flatMapLatest { $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

student1.onNext(greg)
greg.score.accept(20)
student1.onNext(ana)
greg.score.accept(100)
ana.score.accept(82)

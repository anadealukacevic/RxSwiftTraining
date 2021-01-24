import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

//Publish subjects

let publishSubject = PublishSubject<String>()

publishSubject.onNext("Issue 1")

publishSubject.subscribe { event in
    print(event)
}

publishSubject.onNext("Issue 2")
publishSubject.onNext("Issue 3")

publishSubject.onCompleted()

publishSubject.onNext("Issue 4")

publishSubject.dispose()

publishSubject.onNext("Issue 5")

print("--------------------")


//Behavior subjects
let behaviorSubject = BehaviorSubject(value: "Initial value")

//if commented prints initial value
behaviorSubject.onNext("Last issue")

behaviorSubject.subscribe { event in
    print(event)
}

behaviorSubject.onNext("Issue 1")

print("--------------------")


//Replay subjects
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("Issue 1")
replaySubject.onNext("Issue 2")
replaySubject.onNext("Issue 3")

replaySubject.subscribe {
    print($0)
}

replaySubject.onNext("Issue 4")
replaySubject.onNext("Issue 5")
replaySubject.onNext("Issue 6")

print("Subscription 2")
replaySubject.subscribe {
    print($0)
}

print("--------------------")


//Variables
let variable = Variable("Initial value")

variable.value = "Hello RxSwift"

variable.asObservable()
    .subscribe {
        print($0)
    }

let variable2 = Variable([String]())

variable2.value.append("Item 1")

variable2.asObservable()
    .subscribe {
        print($0)
    }

variable2.value.append("Item 2")

print("--------------------")


//Behavior Relay
let relay = BehaviorRelay(value: "Initial value")

relay.asObservable()
    .subscribe {
        print($0)
    }

relay.accept("Hello")

let relay2 = BehaviorRelay(value: [String]())

//rewrites/deletes the initial value
relay2.accept(["Item 1"])

relay2.accept(relay2.value + ["Item 2"])

//2nd way to apply values
var value = relay2.value
value.append("Item 3")
value.append("Item 4")
relay2.accept(value)

relay2.asObservable()
    .subscribe {
        print($0)
    }

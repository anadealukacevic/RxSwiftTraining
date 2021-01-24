import RxSwift

//examples of observable
let observable = Observable.just(1)

let observable2 = Observable.of(1,2,3)

let observable3 = Observable.of([1,2,3])

let observable4 = Observable.from([1,2,3,4,5])

//examples of subscribe and different ways of getting data
observable4.subscribe { event in
   print(event)
}

observable4.subscribe { event in
    if let element = event.element {
        print(element)
    }
}

observable3.subscribe { event in
    if let element = event.element {
        print(element)
    }
}

let subscription4 = observable4.subscribe(onNext: { element in
    print(element)
})

//disposing
subscription4.dispose()

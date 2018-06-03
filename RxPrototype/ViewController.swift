//
//  ViewController.swift
//  RxPrototype
//
//  Created by Michael Long on 6/2/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var disposable1: Disposable? = nil
    var disposable4: Disposable? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        print("Creating observable chain")
        let observable = ObservableInt.just(4)
            .filter { $0 > 0 }
            .map { $0 * 10 }

        print("\n\nSubscription 1")
        print("- Subscription retained but everything else should be disposed.")
        disposable1 = observable
            .subscribe(on: { e in
                print("Subscription handled event: \(e)")
            })

        print("\n\nSubscription 2")
        print("- Subscription set to nil so everything should be disposed.")
        var disposable2: Disposable? = observable
            .subscribe(on: { e in
                print("Subscription handled event: \(e)")
            })
        disposable2 = nil

        print("\n\nSubscription 3")
        print("- Subscription retained but should go out of scope and deallocate.")
        _ = observable
            .subscribe(on: { e in
                print("Subscription handled event: \(e)")
            })

        print("\n\nSubscription 4")
        print("- Test create, everything should be handled.")
        self.disposable4 = ObservableInt.create({ (observer) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                observer.onNext(15)
                observer.onCompleted()
            })
            return NopDisposable()
            })
            .subscribe(on: { e in
                print("Subscription handled event: \(e)")
            })

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            print("\n\nSubscription 5")
            print("- Test create disposed before event is fired.")
            var disposable5: Disposable? = ObservableInt.create({ (observer) -> Disposable in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    observer.onNext(19)
                    observer.onCompleted()
                })
                return NopDisposable()
                })
                .filter { $0 > 0 }
                .subscribe(on: { e in
                    print("Subscription handled event: \(e)")
                })
            disposable5?.dispose() // Early dispose before internal event fires
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            print("\n\nSubscription 6")
            print("- Test publish subject.")
            let subject = PublishSubject()
            let ps1 = subject.subscribe(on: { (e) in
                print("Subscription 1 handled event: \(e)")
            })
            let ps2 = subject.subscribe(on: { (e) in
                print("Subscription 2 handled event: \(e)")
            })
            subject.onNext(10)
            subject.onNext(20)
            subject.onCompleted()
        })

    }

}


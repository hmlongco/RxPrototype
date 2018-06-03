# RxPrototype

Demonstration of alternative RxSwift implementation using source > disposable sink chaining as opposed to the existing RxSwift implementation where a disposable is created and maintained for every element in the subscription chain.

Consider the following RxSwift observable and subscription chain:

```
let d = Observable<Int>.just(4)
   .filter { $0 > 0 }
   .map { $0 * 10 }
   .subscribe(on: { print($0) })
```

### RxSwift

In RxSwift the generated subscription chain would be:

```
Observable 
  > Filter + FilterSink + Disposable(FilterSink, Observable) 
  > Map + MapSink + Disposable(MapSink, FilterSink)
  > Subscription + Disposable(Subscription, MapSink)
```

Basically you end up with a Sink and a Disposable every element in the subscription chain.

In addition, each Sink maintains a reference to the returned disposable, just in case it needs to fire dispose() on an error or completed event.

The rationale for this is basically to end up with a single disposable return by the subscription that, even if held after a an error or completed event, contains nothing. Everything held or referenced by the disposable has been properly disposed and deallocated.

While workable, the parallel disposable chain with all of its cross references felt somewhat clunky, not to mention the additional disposable object allocation made for every item in the chain.

### RxPrototype

In RxPrototype, the pattern is:

```
ObservableSource > ObservableSink > Sink
```

Where ObservableSource, ObservableSink, and Sink are not just data sources or sinks, but are also disposables in their own right. Each element in the chain maintains a link to its source (to implement the disposal chain) and observer (for event forwarding).

So, given the same observable subscription chain shown above, the actual "behind the scenes" sink chain generated would be:

```
Observable
  > ObservableSource
  > Filter + FilterSink 
  > Map + MapSink
  > SubscriptionSink
```

Here, the end result is a SubscriptionSink that is also appears to be disposable. 

Like the RxSwift implementation, on completion or error it too contains nothing, even if held after the error or completed event. Everything held or referenced in the subscription chain is properly disposed and deallocated.

As proof of concept, RxPrototype implements Create, Just, Filter, Map, PublishSubject, and Disposable.

In order to focus on the architecture, RxPrototype's type is fixed as Int, and not a generic type T.

### Sample Code

The following sample code and resulting trace log demonstrates the concept.

```
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

```

### Logs:

```
Creating observable chain
Just observing
Just creating
Filter observing
Filter created
Map observing
Map created


Subscription 1
- Subscription retained but everything else ~~should~~ be disposed.
SubscriptionSink subscribing
SubscriptionSink created
Map subscribing
MapSink created
Filter subscribing
FilterSink created
Just subscribing
JustSource created
JustSource running
FilterSink on event next(4)
FilterSink forwarding event next(4)
MapSink on event next(4)
MapSink forwarding event next(40)
SubscriptionSink on event next(40)
Subscription handled event: next(40)
FilterSink on event completed
FilterSink forwarding event completed
MapSink on event completed
MapSink forwarding event completed
SubscriptionSink on event completed
Subscription handled event: completed
JustSource disposed
FilterSink disposed
MapSink disposed
SubscriptionSink disposed
MapSink disposed
FilterSink disposed
JustSource deinit
FilterSink deinit
MapSink deinit


Subscription 2
- Subscription set to nil so everything should be disposed.
SubscriptionSink subscribing
SubscriptionSink created
Map subscribing
MapSink created
Filter subscribing
FilterSink created
Just subscribing
JustSource created
JustSource running
FilterSink on event next(4)
FilterSink forwarding event next(4)
MapSink on event next(4)
MapSink forwarding event next(40)
SubscriptionSink on event next(40)
Subscription handled event: next(40)
FilterSink on event completed
FilterSink forwarding event completed
MapSink on event completed
MapSink forwarding event completed
SubscriptionSink on event completed
Subscription handled event: completed
JustSource disposed
FilterSink disposed
MapSink disposed
SubscriptionSink disposed
MapSink disposed
FilterSink disposed
JustSource deinit
FilterSink deinit
MapSink deinit
SubscriptionSink deinit


Subscription 3
- Subscription retained but should go out of scope and deallocate.
SubscriptionSink subscribing
SubscriptionSink created
Map subscribing
MapSink created
Filter subscribing
FilterSink created
Just subscribing
JustSource created
JustSource running
FilterSink on event next(4)
FilterSink forwarding event next(4)
MapSink on event next(4)
MapSink forwarding event next(40)
SubscriptionSink on event next(40)
Subscription handled event: next(40)
FilterSink on event completed
FilterSink forwarding event completed
MapSink on event completed
MapSink forwarding event completed
SubscriptionSink on event completed
Subscription handled event: completed
JustSource disposed
FilterSink disposed
MapSink disposed
SubscriptionSink disposed
MapSink disposed
FilterSink disposed
JustSource deinit
FilterSink deinit
MapSink deinit
SubscriptionSink deinit


Subscription 4
- Test create, everything should be handled.
Create observing
Create creating
SubscriptionSink subscribing
SubscriptionSink created
Create subscribing
CreateSource created
CreateSource running
CreateSource on event next(15)
CreateSource forwarding next(15)
SubscriptionSink on event next(15)
Subscription handled event: next(15)
CreateSource on event completed
CreateSource forwarding completed
SubscriptionSink on event completed
Subscription handled event: completed
CreateSource disposed
SubscriptionSink disposed
CreateSource deinit


Subscription 5
- Test create disposed before event is fired.
Create observing
Create creating
Filter observing
Filter created
SubscriptionSink subscribing
SubscriptionSink created
Filter subscribing
FilterSink created
Create subscribing
CreateSource created
CreateSource running
CreateSource disposed
FilterSink disposed
FilterSink deinit
SubscriptionSink disposed
SubscriptionSink deinit
CreateSource on event next(19)
CreateSource on event completed
CreateSource deinit


Subscription 6
- Test publish subject.
PublishSubject created
SubscriptionSink subscribing
SubscriptionSink created
PublishSubject subscribing
PublishSubjectSubscription creating
SubscriptionSink subscribing
SubscriptionSink created
PublishSubject subscribing
PublishSubjectSubscription creating
PublishSubject forwarding event next(10)
PublishSubjectSubscription forwarding event next(10)
SubscriptionSink on event next(10)
Subscription 2 handled event: next(10)
PublishSubjectSubscription forwarding event next(10)
SubscriptionSink on event next(10)
Subscription 1 handled event: next(10)
PublishSubject forwarding event next(20)
PublishSubjectSubscription forwarding event next(20)
SubscriptionSink on event next(20)
Subscription 2 handled event: next(20)
PublishSubjectSubscription forwarding event next(20)
SubscriptionSink on event next(20)
Subscription 1 handled event: next(20)
PublishSubject forwarding event completed
PublishSubjectSubscription forwarding event completed
SubscriptionSink on event completed
Subscription 2 handled event: completed
PublishSubject removing 2
PublishSubjectSubscription disposed
SubscriptionSink disposed
PublishSubjectSubscription forwarding event completed
SubscriptionSink on event completed
Subscription 1 handled event: completed
PublishSubject removing 1
PublishSubjectSubscription disposed
SubscriptionSink disposed
SubscriptionSink deinit
SubscriptionSink deinit
PublishSubject deinit
```

### Conclusion:

As shown, the RxPrototype architecture chain generates fewer objects and cross-references (retain cycles) per subscription chain.

That said, this isn't really a proposal to rearchitect RxSwift.

It exists solely as a proof-of-concept to show that an alternative behind the scenes "disposable sink" methodology could be implemented, and it would have the same functionality and exhibit the same behavior as the current RxSwift implementation.

Doing the RxPrototype project was a fun weekend project that explored RxSwift and in the process gave me a deeper understanding of its internal architecture.

And if you think that I have a strange idea of what constitutes "fun".... then you're right. ;)

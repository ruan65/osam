# OSAM
![GitHub Logo](images/logo2.jpg)

#Introduction

Osam - it is state management library inspired by redux, bloc and SOLID principles.
If your are familiar with functional programming you should probably use built_redux but here is a lot of benefits
then Bloc or Build_redux.

#Glossary

BaseState
> it is mutable domain element witch contains data and state methods. BaseState streaming it self every
time, when you calling methods by Event. Also BaseState can stream every property if you listen it.
Cool feature: property streams and state streams do NOT stream it self if previous state is equal

Event
> Here is two types of this element. First - Event.modify, this is Event witch stores a reducer - just a lambda to 
>call method of the state. Like:
```dart
(state,_) => state..increment();
```
>And Bundle to send a something for method:
```dart
(state, bundle) => state..increment(bundle);
```
>You can specify a type for your event to catch event in middleware, enum is Good for this case.
>Second - Event.sideEffect. Try to guess... it for side effects. It is contains a bundle and type, to catch it
> in middleware to.

Middleware
> Middleware it is Domain element too, with you business logic conditions.
> Every event is throwing inside every middleware. That means that you can send another event if you catch target event.
>Example:
```dart
if (event.type == EventType.increment) {
        store.dispatchEvent(
            event: Event.modify(
                reducer: (state, _) => state..increment(1), type: EventType.increment));
    }
    return nextEvent(true);
```
> Notice: return nextEvent with true if you want other middlewares can catch your target event. Or false if you
> wouldn't.

Store
>Domain element too. Stores your domain tree of states, starting from your appState entry point.
>and stack of middlewares.

#Rules


Osam - it is about strong rules. Interfaces and inheritance of the domain and presentation layer is very strong.
In my opinion it is very necessary if you are working in team.
BaseState stream it self only if you dispatching Events to Store.
Your Middlewares, BaseStates and Presenters working, only if you extending this library elements.
To understand how everything works, I would recommend look at examples.

#Presentation
If you familiar with a provider or inherited widget, you will not have a problems to use it.
This is very simple to provide Store for every widgets inside you widget tree. But it is automatically provided for 
PresenterProviders.

# Store and StoreProvider
In main function create a instance of Store with your state and middlewares. Put store and your entry point widget
in to Store provider
```dart
 final store = Store(AppState(), middleWares: []);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StoreProvider(
        child: MyHomePage(),
        store: store,
      ),
    );
  }
```

#Presenter and PresenterProvider
Well, good practices it is make you ui is dump as possible. And here coming the Presenter. Presenter is good for send
events, providing streams and initial data for your widgets.
To specify presenter for you widget just use PresenterProvider. Put inside it you widget as a child and instance of
Presenter.
```dart
PresenterProvider<Store<AppState>, ExamplePresenter>(
        presenter: ExamplePresenter(),
        child: Button(),
      ),
```
Get presenter by using context it is very easy:
```dart
final presenter = PresenterProvider.of<ExamplePresenter>(context);
```
Example of presenter:
```dart
class ExamplePresenter<S extends Store<AppState>> extends Presenter<S> {
  StreamSubscription propertySub;
  StreamController<int> modelBroadcaster;

  @override
  void init() {
    modelBroadcaster = StreamController<int>();
    store.nextState(store.state).listen((data) {});
  }

  void increment() =>
      store.dispatchEvent(event: Event.modify(reducer: (state, _) => state..increment(1)));

  List<int> get initialData => store.state.count;

  Stream<List<int>> get stream => store.state.propertyStream<List<int>>((state) => state.count);

  @override
  void dispose() {
    propertySub?.cancel();
    modelBroadcaster?.close();
  }
}
```

#Conclusion
Well, I hope this library is useful for you. Here you can see examples, send your apps in github to fill this list
 =) Thanks! :
 https://github.com/Renesanse/popular_news
 https://github.com/Renesanse/osam/tree/master/example

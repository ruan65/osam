# OSAM
![GitHub Logo](images/logo2.jpg)
This is state management implements best solutions of Redux, Bloc, Provider and SOLID principles.
---
## Glossary

- [Domain layer]

`Store` - is a `Singleton` that stores your `State` of application.

`State` - is a class that contains data like primitives, collections and other states.

`Event` - is a parent class for `ModificationEvent` and `SideEffectEvent` that can contains "bundle" (payload).

`ModificationEvent` - is Event that implements `Reducer` to modify `State` of application.

`SideEffectEvent` - is Event to handle with "side effect" (BD, API ... requests) in `Middleware`'s.

`Reducer` - is a method in `ModificationEvent` that calls method of target `State` and returns it.

`Middleware` - is a class that working between sending event and calling it's `Reducer` and contains `Conditin`'s to
 add and handle with your business logic.
 
- [Presentation layer]

`StoreProvider` - is a wrapper of your entry point widget and `Store` to provide `Store` for all of `Presenter`'s using
 Provider package (https://pub.dev/packages/provider).
 
`Presenter` - is a class that have access to `Store` and being glue based of `Stream`'s to separate domain and
 presentation layers.
 
`PresenterProvider` - is a wrapper of your widget and `Presenter` to provide `Presenter` for all of widgets down of
 widget tree using Provider package.
 
- [Rules] 

1) `stateStream` and `propertyStream` emits it's state/property only if last state is not equal to next state/property.

2) `State` sends new it's condition to `stateStream` only by dispatching `ModificationEvent` to `Store`

3) Modify your `State`'s only by dispatching `ModificationEvent`'s.

4) Don't call `StoreProvider` and `Store` in widgets, use `Presenter`'s and `PresenterProvider`'s to handle with `Store`.

5) Use `Middlewares` for all of your business rules.

6) "Recommendation" try to use worker_manager package to save your fps. https://pub.dev/packages/worker_manager

- [Special features]

1) `State` supports comparison based on comparison of its meaningful `props`. So you will never get the same as
 previous state in `stateStream`. So your UI won’t be called with the same data.
 
2) `State` is the mutable class. Garbage collector won’t work so often. And already created Objects will be reused
 instead of creating new same ones.
 
3) `Store` tracks app lifecycle and save its `State` when app goes to background and restore it when app back to
 foreground using Hive DB (https://pub.dev/packages/hive). So user can continue with the place/screen he stopped.
 
4) `Presenter` supports `dispose`. So if user goes to another screen all needed clean up and closing subscriptions to
 `State`'s will be done.
 
5) In `Presenter`'s you can listen to not only all new `State` but also `propertyStream` for listening only one
 property (which
 can be property of State or mapped Object from `State`). So UI will be rebuilt less time.

__Best way I know, to understand how to use it - it's look at examples, enjoy ! =)__

# Examples

 https://github.com/Renesanse/popular_news
 
 https://github.com/Renesanse/osam/tree/master/example
 
#Author

- [Daniil](https://github.com/renesanse) telegram: @dsrenesanse


# OSAM
![GitHub Logo](images/logo2.jpg)


New state management approach with best parts of redux and bloc (Business logic component) pattern with additional features.

Basic concept
There is one or more `Store` objects that handle `State` of application.
State changes is based on events. 
`Presenter` dispatch `Event` as a result of some UI action.
 If something must be changed in the `State` - `ModificationEvent` should be used with `Reducer` inside. If event is not modification `SideEffectEvent` can be used or any custom event type. 
`Event` can be handled by `Middleware` from the `Store` if it satisfies its conditions. In this case side effects will be handled like network calls, API calls, etc.
`ModificationEvent` with its `Reducer` modifies and update `State`’s `stateStream`. 
And this `stateStream` usually is base for `Store`’s `nextState`. So UI gets a new state to show.

Special features:
`State` supports comparison based on comparison of its meaningful `props`. So you will never get the same as previous state in `stateStream`. So your UI won’t be called with the same data.
`State` is the mutable class. Garbage collector won’t work so often. And already created Objects will be reused instead of creating new same ones.
`Store` tracks app lifecycle and save its `State` when app goes to background and restore it when app back to foreground. So user can continue with the place/screen he stopped.
`Presenter` supports `dispose`. So if user goes to another screen all needed clean up will be done.
Support passing `Presenter` and `Store` through widget tree with `Provider` package helps. So you don’t need to pass it deep with the constructors.
In UI you can listen to not only all new `State` events but also `propertyStream` for listening only one property (which can be property of State or mapped Object from `State`). So UI will be rebuilt less time.


# Examples

 https://github.com/Renesanse/popular_news
 
 https://github.com/Renesanse/osam/tree/master/example


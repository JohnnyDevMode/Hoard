# Hoard
> Generic tree-based object cache for Swift development.

## Overview
The point of Hoard is to provide a simple object cache using a tree structure instead of a flat map-based cache.  The Hoard cache uses nested contexts and segmented keys to support the tree structure.  Another feature of the Hoard cache is the caller to a `get` request can provide an optional loader closure to load and put the item if not found.  This can be done either synchronous or asynchronously and provides a solid base for a passthrough cache.

## Getting Started

### Installation

Add the Hoard Pod to your Podfile.
```ruby
target 'MyTarget' do
  pod 'Hoard'
end
```

Be sure to use the target of your Xcode project instead of 'MyTarget'.  After adding those lines, navigate to the folder containing the Podfile in your Terminal app.  Now install the pod (and any other necessary project dependencies) by executing the command: `pod install`

### Usage

At this point, you should be ready to interact with the library using the Swift framework import:

```swift
import Hoard
```

Or using the Objective-C framework:

```
@import Hoard;
```


## Main Types

### Key

All items are stored in the cache using a segmented key.  Each segment of the key represents a branch in the tree except for the last segment which will always be treated as a leaf in the tree.  

The primary way to create a `Key` is using the `Key.from` function.

Simple:
```swift
let key = Key.from("somekey")
```

Complex:
```swift
let key = Key.from("root", "branch", "leaf")
```

### Keyable

In order to simplify the usage of keys, the cache can use anything that adheres to the `Keyable` protocol.  This allows simplistic interaction with full segmented keys support.  Hoard provides `Keyable` extensions for `String` and `NSURL`.  Both of these will create complex keys representing a path like structure. So any string will be separated by `/` character and URLS are treated the same way, but also include any host information as its root segment.

String paths:
```swift
let keyOne = "somekey".asKey()
let keyTwo = Key.from("somekey")
assert(keyOne == keyTwo)
```

```swift
let keyOne = "root/branch/leaf".asKey()
let keyTwo = Key.from("root", "branch", "leaf")
assert(keyOne == keyTwo)
```

URLs:
```swift
let url = NSURL(string: "http://cdn.google.com/some/asset.png")!
let keyOne = url.asKey()
let keyTwo = Key.from("cdn.google.com", "some", "asset.png")
assert(keyOne == keyTwo)
```

### Context

The `Context` protocol represents a location in the tree to store items. All primary functions on the `Context` require a `Keyable` to operate.  The more interesting aspect is the tree nature of the context.  It is possible for an item in a context to be another context and create multiple branches.  These nested branches can have different behavior and can be independently manipulated.

#### Storing Items

Putting an item is as one would expect.  You simply invoke the `.put` function with a key and `Any` value.

```swift
let context = ...
context.put("somekey", "value")
```

The `Context` class will automatically create any child contexts required to support the provided key.  If the key provided is complex, it will create any intermediate contexts.  

```swift
let context = ...
let key = Key.from("root", "mid", "leaf")
context.put(key, "value")
```

Each item in the cache is stored with set valid for time.  The default is 1 hour, but it can be overridden per item as part of the put call by passing the `validFor` parameter.

```swift
let context = ...
context.put("somekey", "value", validFor: 60) // Valid for 1 minute
```


#### Retrieving Items

Getting an item from the context is pretty straight forward as well.  Invoke the `.get` function with a key.  The result is optional as an item may not exist at that location.

```swift
let context = ...
let result = context.get("somekey")
```

The get function also allows a captured type.  If you use a type capture it will return `nil` if the value for this key is not of the requested type.

```swift
let context = ...
let result : String? = context.get("somekey")
```

Items can also be retrieved using an asynchronous callback mechanism.

```swift
let context = ...
context.getAsync(key: "somekey", callback: { (result: String?) in
  print(result)
})
```

With a loader function to be called when a item is not found in cache:
```swift
let context = ...
context.getAsync(key: "somekey", loader: { done in
  done("value")
}, callback: { (result: String?) in
  print(result)
})
```

#### Removing Items

Again, you get this....

```swift
let context = ...
context.remove("somekey")
```

One thing to keep in mind, is that removing with a key that represents a child context will remove the context and all child items in the tree.  This a powerful mechanism for pruning the tree efficiently.  

```swift
let context = ...
context.put(Key.from("users", "1243"), userOne)
context.put(Key.from("users", "2345"), userTwo)
context.put(Key.from("users", "3456"), userThree)
context.remove(Key.from("users"))
```

#### Getting All Items at a Context

There may be some interesting reasons to get all the items under a give context.  This can be achieved with the `.children` function.  This function will return all direct child items of the requested type.  It will ignore any child items that do not match the requested type.

```swift
let context = ...
let stringChildren : Set<String> = context.children()
```

#### Cleaning Context

At times it may be useful to clean the context and remove all the expired items.  This can be done by invoking the `.clean` function on the context.  This will recursively clean the context and all child context of expired items.

```swift
let context = ...
context.clean()
```

There is also an option to deep clean the the context.  A deep cleaning will remove expired options as well as items that have not been recently accessed.  There is a threshold how what should be cleaned that is based on the `validFor` for the item.  So items with longer `validFor` times will be given more time before they are affected by a depp clean.

```swift
let context = ...
context.clean(deep: true)
```

#### Clearing the Context

It is also possible to clear all entries from a context.  Clearing will remove everything in the context.

```swift
let context = ...
context.clear()
```

### MemoryContext

The `MemoryContext` class is a basic in-memory only context.  This will not store anything to disk or do any sophisticated pass through loading.

#### Creating

```swift
let context = MemoryContext()
```

### Cache

The `Cache` class represents the root `Context` for the Hoard library.  

Creating a Cache:

```swift
let cache = Cache()
```

Using the shared instance:
```swift
let cache = Cache.shared
```

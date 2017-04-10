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


## Main Classes

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

### Context

The `Context` class represents a location in the tree to store items. All primary functions on the `Context` require a `Key` to operate.  The more interesting aspect is the tree nature of the context.  It is possible for an item in a context to be another context and create multiple branches.  

#### Creating a Context

```swift
let context = Context()
```

#### Storing Items

Putting an item is as one would expect.  You simply invoke the `.put` function with a key and `Any` value.

```swift
let context = ...
let key = Key.from("somekey")
context.put(key, "value")
```

The `Context` class will automatically create any child contexts required to support the provided key.  If the key provided is complex, it will create any intermediate contexts.  

```swift
let context = ...
let key = Key.from("root", "mid", "leaf")
context.put(key, "value")
```

#### Retrieving Items

Getting an item from the context is pretty straight forward as well.  Invoke the `.get` function with a key.  The result is optional as an item may not exist at that location.

```swift
let context = ...
let key = Key.from("somekey")
let result = context.get(key)
```

The get function also allows a captured type.  If you use a type capture it will return `nil` if the value for this key is not of the requested type.

```swift
let context = ...
let key = Key.from("somekey")
let result : String? = context.get(key)
```

You can spiff it up a bit by using a default value.  This will be returned if an item doesn't exist for this key.

```swift
let context = ...
let key = Key.from("somekey")
let result : String? = context.get(key, defaultValue: "somevalue")
```

You can also provide a loader function that will be called if the key does not exist. This is similar to the default value, but difference in two major ways.  The loader function allows complex logic over a simple value and more importantly performs a `.put` of the result of the loader function.  

```swift
let context = ...
let key = Key.from("somekey")
let result : String? = context.get(key, loader: {
  return "somevalue"
})
```

#### Removing Items

Again, you get this....

```swift
let context = ...
let key = Key.from("somekey")
context.remove(key)
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

As previously mentioned, sub-context items are possible in the `Context`.  There may be some interesting reasons to get all the items under a give context.  This can be achieved with the `.children` function.  This function will return all direct child items of the requested type.  It will ignore any child items that do not match the requested type.

```swift
let context = ...
let key = Key.from("root", "mid")
let stringChildren : Set<String> = context.children(key: key)
```

### Cache

All access to store or retrieve items go through the `Cache` class. The `Cache` class represents the root `Context` for the Hoard library.  

Creating a Cache:

```swift
let cache = Cache()
```

Using the shared instance:
```swift
let cache = Cache.shared
```

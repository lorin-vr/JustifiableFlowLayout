# JustifiableFlowLayout

A SwiftUI layout that arranges a collection of items from left to right and top to bottom, in sequential order. 

By default it is a standard flow layout, where an exact spacing is applied between items. For example:

<img src=demo/default-similar-widths.png width="250"> <img src=demo/default-varied-widths.png width="600">

It can also be used as a 'justified' flow layout, where the widest item determines the spacing and alignment, creating an even appearance of neat columns. For example:

<img src=demo/justified-similar-widths.png width = 250> <img src=demo/justified-varied-widths.png width="600">

Animation is supported. Here's an example of adding and removing items simultaneously:

![Animation showing the addition and removal of items simultaneously](demo/add-remove-animate.gif)

## Usage

Sample:

```swift
import JustifiableFlowLayout

let uniqueWords = ["cloud", "hill", "thunder", "if", "run", "fright", "just", "twenty", "agent", "theatre", "ink", "so", "rig", "week", "range", "today"]

JustifiableFlowLayout(minSpacing: 10, shouldJustify: false) {
    ForEach(uniqueWords, id: \.self) { word in
        Text(word)
            .padding(10)
            .border(Color.mint, width: 2)
    }
}

```

`JustifiableFlowLayout` also works well inside a `ScrollView`.


## Installation

### Swift package manager

Add the swift package to your project:

```
https://github.com/lorin-vr/JustifiableFlowLayout.git
```

## Discussion

`JustifiableFlowLayout` can be used as an alternative to SwiftUI collection view layouts like `Grid` and `LazyVGrid`.

Unlike `LazyVGrid`, `JustifiableFlowLayout` lays out its items all at once. This potentiallys allows for more performant layout and animation, but may not be suitable for a large collection of items.

Unlike `Grid`, you don't specify the number of rows required. `JustifiableFlowLayout` will decide how many rows it needs based on the item sizes. When using `JustifiableFlowLayout`, there is no need to define `GridItem` or `GridRow`.

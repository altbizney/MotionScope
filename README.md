# MotionScope (Preview Release)
![](https://i.imgur.com/vOH1uh0.gif)


Explode and explore dimensions in Software Animation. It’s like a
console for an engineer, or a histogram for a photographer.

http://thinko.com/motionscope

## Installation

Save a copy of `MotionScope.coffee` in your projects `modules` sub-folder.

```
cd /your/framer/project
curl https://rawgit.com/yothinko/MotionScope/master/MotionScope.coffee -o modules/MotionScope.coffee
```

## Usage

Specify the properties of any regular Framer layers you wish to plot.

```
(require "MotionScope").load((scope) ->
  # `modal` is the layer you want to attach the scope to
  scope.plot(modal, 'y')
  scope.plot(modal, 'scale')
)
```

Optionally, you can configure the MotionScope graph.

```
(require "MotionScope").load({
  parent: Scope
  reset: ResetButton
}, (scope) ->
  scope.plot(modal, 'x')
  scope.plot(modal, 'y')
)
```

The plot method can be configured as well.

```
(require "MotionScope").load({
  parent: Scope
  reset: ResetButton
}, (scope) ->
  scope.plot(oval, 'opacity', {
    color: '#FFA29C'
  })
)
```

### MotionScope Options

* `parent`: pass a Framer layer to use as the MotionScope parent. The graph
  will be sized to the width and height of the parent layer.
* `width`, `height`: set the graph size without adding it to a parent layer.
* `reset`: pass a Framer layer to use as a reset button. Clicking the button
  will clear the graph.

### Plot Options

* `name`: label for the chart legend. Defaults to the property name.
* `color`: color for the graph line. Defaults to `Utils.randomColor` if
  not specified.
* `min`, `max`: sets the extent of the line. If not set, continuously adjusts
  to the largest and smallest values seen.

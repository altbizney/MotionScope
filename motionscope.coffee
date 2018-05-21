class Graph
	_instance = null

	constructor: () ->
		@time = 0
		@plots = {}

		@scope = MotionScope.get()

		@create()
		@tick()

	@get: =>
		_instance ?= new Graph()

	create: =>
		# x is global, for time
		@x = d3.scale.linear().range([0, @scope.options.width - (@scope.options.margin * 2)])

		# root
		@svg = d3.select(@scope.options.parent._element).append('svg')
			.attr('width', @scope.options.width)
			.attr('height', @scope.options.height)
			.style('background', 'black')
			.append('g')

		# 0%
		@svg.append("line")
			.attr("x1", @scope.options.margin)
			.attr("y1", @scope.options.margin)
			.attr("x2", @scope.options.width - @scope.options.margin)
			.attr("y2", @scope.options.margin)
			.style("stroke-width", 1)
			.style("stroke-dasharray", '8, 5')
			.style("stroke", '#979797')

		# 100%
		@svg.append("line")
			.attr("x1", @scope.options.margin)
			.attr("y1", @scope.options.height - @scope.options.margin)
			.attr("x2", @scope.options.width - @scope.options.margin)
			.attr("y2", @scope.options.height - @scope.options.margin)
			.style("stroke-width", 1)
			.style("stroke-dasharray", '8, 5')
			.style("stroke", '#979797')

		# 50%
		@svg.append("line")
			.attr("x1", @scope.options.margin)
			.attr("y1", @scope.options.height * 0.5)
			.attr("x2", @scope.options.width - @scope.options.margin)
			.attr("y2", @scope.options.height * 0.5)
			.style("stroke-width", 1)
			.style("stroke", '#979797')

		# plot paths parent
		@paths = @svg.append('g')
			.attr('transform', "translate(#{@scope.options.margin}, #{@scope.options.margin})")

		# legend
		@legend = d3.select(@scope.options.parent._element)
			.append("div")
			.style('position', 'absolute')
			.style('top', '0px')
			.style('left', '0px')
			.style('width', "#{@scope.options.width - 10}px")
			.style('height', "#{@scope.options.height - 40}px")
			.style('display', 'flex')
			.style('justify-content', 'flex-end')
			.style('align-items', 'flex-end')

		# logo
		@svg.append('path')
			.attr('transform', "translate(#{@scope.options.width - 107 - 10}, #{@scope.options.height - 12 - 10})")
			.attr("fill", '#D8D8D8')
			.attr('d', 'M10.755 11V.431h-1.53L5.606 9.176H5.49L1.871.431H.341V11h1.23V2.929h.088l3.332 7.998h1.113l3.333-7.998h.088V11h1.23zM17.662.182c1.504 0 2.686.498 3.545 1.494.86.996 1.29 2.342 1.29 4.036 0 1.69-.43 3.035-1.286 4.036-.857 1-2.04 1.501-3.549 1.501-1.514 0-2.701-.5-3.563-1.501-.862-1.001-1.293-2.347-1.293-4.036 0-1.7.436-3.046 1.308-4.04.871-.993 2.054-1.49 3.548-1.49zm0 1.216c-1.074 0-1.926.388-2.556 1.165-.63.776-.945 1.826-.945 3.149 0 1.309.309 2.356.927 3.142.617.786 1.475 1.18 2.574 1.18 1.084 0 1.935-.394 2.553-1.18.617-.786.926-1.833.926-3.142 0-1.323-.31-2.373-.93-3.15-.62-.776-1.47-1.164-2.549-1.164zM27.797 11V1.618h3.406V.43h-8.13v1.187h3.406V11h1.318zm6.526 0V.431h-1.318V11h1.318zM41.23.182c1.504 0 2.686.498 3.545 1.494.86.996 1.289 2.342 1.289 4.036 0 1.69-.428 3.035-1.285 4.036-.857 1-2.04 1.501-3.549 1.501-1.514 0-2.701-.5-3.563-1.501-.862-1.001-1.293-2.347-1.293-4.036 0-1.7.436-3.046 1.307-4.04.872-.993 2.055-1.49 3.549-1.49zm0 1.216c-1.074 0-1.926.388-2.556 1.165-.63.776-.945 1.826-.945 3.149 0 1.309.309 2.356.927 3.142.617.786 1.475 1.18 2.574 1.18 1.084 0 1.935-.394 2.552-1.18.618-.786.927-1.833.927-3.142 0-1.323-.31-2.373-.93-3.15-.62-.776-1.47-1.164-2.549-1.164zM49.418 11V2.804h.118L55.27 11h1.281V.431H55.25v8.225h-.118L49.396.431h-1.281V11h1.303zm9.09-2.761c.068.913.46 1.643 1.175 2.19.716.547 1.632.82 2.75.82 1.212 0 2.172-.287 2.883-.86.71-.574 1.065-1.347 1.065-2.319 0-.776-.238-1.394-.714-1.853-.476-.459-1.26-.825-2.355-1.098l-1.105-.293c-.728-.186-1.25-.408-1.564-.667a1.246 1.246 0 0 1-.473-1.01c0-.538.214-.967.641-1.29.428-.322.993-.483 1.696-.483.659 0 1.2.153 1.622.458.423.305.68.728.773 1.27h1.326c-.054-.854-.425-1.555-1.114-2.102-.688-.546-1.543-.82-2.563-.82-1.118 0-2.02.277-2.707.831-.686.555-1.029 1.28-1.029 2.18 0 .751.218 1.353.652 1.805.435.451 1.13.8 2.088 1.044l1.355.351c.727.18 1.262.42 1.604.718.341.298.512.671.512 1.12 0 .523-.233.956-.7 1.3-.465.345-1.055.517-1.768.517-.752 0-1.372-.164-1.86-.49-.489-.328-.774-.767-.857-1.32h-1.333zm14.084 3.01c1.123 0 2.072-.29 2.846-.868.774-.579 1.249-1.354 1.424-2.325h-1.34a2.476 2.476 0 0 1-1.036 1.446c-.525.354-1.156.531-1.894.531-1.015 0-1.821-.388-2.417-1.164-.595-.777-.893-1.827-.893-3.15 0-1.328.296-2.38.89-3.157.593-.776 1.397-1.164 2.413-1.164.728 0 1.355.199 1.882.597.528.398.88.939 1.055 1.622h1.34c-.156-1.02-.63-1.848-1.42-2.483C74.65.5 73.697.182 72.584.182c-1.436 0-2.57.496-3.406 1.487-.835.991-1.252 2.341-1.252 4.05 0 1.704.418 3.052 1.256 4.043.837.991 1.974 1.487 3.41 1.487zM83.286.182c1.504 0 2.685.498 3.545 1.494.859.996 1.289 2.342 1.289 4.036 0 1.69-.429 3.035-1.286 4.036-.857 1-2.04 1.501-3.548 1.501-1.514 0-2.702-.5-3.564-1.501-.861-1.001-1.292-2.347-1.292-4.036 0-1.7.435-3.046 1.307-4.04.872-.993 2.054-1.49 3.549-1.49zm0 1.216c-1.075 0-1.927.388-2.557 1.165-.63.776-.944 1.826-.944 3.149 0 1.309.309 2.356.926 3.142.618.786 1.476 1.18 2.575 1.18 1.084 0 1.934-.394 2.552-1.18.618-.786.927-1.833.927-3.142 0-1.323-.31-2.373-.93-3.15-.62-.776-1.47-1.164-2.55-1.164zM90.17.43h3.992c1.001 0 1.815.319 2.443.956.627.637.94 1.459.94 2.465 0 .986-.318 1.795-.955 2.428-.637.632-1.451.948-2.443.948H91.49V11H90.17V.431zm1.319 1.172v4.453h2.329c.752 0 1.335-.193 1.75-.578.415-.386.623-.928.623-1.626 0-.728-.204-1.285-.612-1.67-.407-.386-.995-.579-1.761-.579h-2.33zm14.524 8.21h-5.23V6.181h4.959V5.009h-4.959V1.618h5.23V.43h-6.548V11h6.548V9.813z')

	addLegend: (name, color) =>
		name += " position" if name in ['x', 'y']

		# bullet
		@legend.append("div")
			.style('vertical-align', 'middle')
			.style("width", "15px")
			.style("height", "15px")
			.style("border-radius", "100px")
			.style('margin', '0 0 0 20px')
			.style("background-color", color)

		# label
		@legend.append("div")
			.style("font", "normal 15px Menlo, monospace")
			.style('margin', '0 0 0 10px')
			.text(name)

	y: =>
		d3.scale.linear().range([@scope.options.height - (@scope.options.margin * 2), 0])

	timeInterval: (d, i) =>
		@x(i + @time - @scope.options.limit)

	draw: =>
		# shift time axis
		@x.domain [@time - @scope.options.limit, @time]

		# redraw plots
		for name, plot of @plots
			plot.draw()

	tick: =>
		# queue next tick
		requestAnimationFrame(@tick)

		# time is global for the graph
		@time++

		# resample plot data
		for name, plot of @plots
			plot.sample()

		# redraw graph
		@draw()


class PlotLine
	constructor: (@options={}) ->
		@options.color ?= Framer.Utils.randomColor().toHexString()
		@options.name ?= @options.prop
		@options.key ?= "#{@options.layer.name}_#{@options.prop}"

		@options.min ?= 0
		@options.max ?= 1

		@scope = MotionScope.get()
		@graph = Graph.get()

		# return if it already exists
		# TODO: remap to new instance of layer on live reload
		return if @graph.plots[@options.key]

		@y = @graph.y()

		@line = d3.svg.line().x(@graph.timeInterval).y((d) => @y(d))

		@data = []

		@path = @graph.paths.append('path')
      .data([@data])
      .attr('class', "#{@options.key} line")
			.style("stroke-linejoin", 'round')
			.style("stroke-linecap", 'round')
			.style('stroke-width', 5)
			.style('fill', 'transparent')
      .style('stroke', @options.color)

		@graph.plots[@options.key] = @

		@graph.addLegend(@options.name, @options.color)

	sample: () =>
		@data.push @options.layer[@options.prop]

		if @data.length > @scope.options.limit
			@data.shift()

		@path.attr('d', @line)

	draw: () =>
		extent = d3.extent(@data)

		# stretch min/max to extent
		@options.min = Math.min(@options.min, extent[0])
		@options.max = Math.max(@options.max, extent[1])

		@y.domain [@options.min, @options.max]

class MotionScope extends Framer.BaseClass
	_instance = null

	constructor: (@options={}) ->
		@options.width ?= 600
		@options.height ?= 600
		@options.margin ?= 75
		@options.limit ?= 300

		# use parents size if specified
		if @options.parent
			@options.parent.index = -90210
			@options.width = @options.parent.width
			@options.height = @options.parent.height
		else
			@options.parent = Framer.Device.content

		if @options.reset
			@options.reset.onClick =>
				@.reset()

	@get: (options={}) ->
		_instance ?= new MotionScope(options)

	@load: (options={}, callback) ->
		Utils.domLoadScript('https://d3js.org/d3.v3.min.js', ->
			if typeof options == 'function'
				callback = options
				options = {}

			callback(MotionScope.get(options))
		)

	reset: ->
		for key, plot of Graph.get().plots
			plot.data.splice(0)

	# add plot line to graph, after first paint
	plot: (layer, prop, options={}) ->
		setTimeout(=>
			options.layer ?= layer
			options.prop ?= prop

			new PlotLine(options)
		, 0)

module.exports = MotionScope

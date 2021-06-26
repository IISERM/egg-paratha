### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 4ae20254-92ed-11eb-2175-330d93400a78
using PlutoUI

# ╔═╡ 5c282396-92f3-11eb-26c2-d367635c3b0d
using Plots

# ╔═╡ 60e719be-92dd-11eb-3ca0-e1a70016febb
md"# N Body problem

The n body problem is one which says that even if you know the pairwise interaction in a system, there does not in general exist an _analytical_ solution for the state of the system. Hence, we have to simulate the system numerically.
"

# ╔═╡ 7ae2a8f8-9326-11eb-0caf-0d8ff40df358
begin
	function makedraw()
		html"""<script>
	// create canvas element and append it to document body
	var canvas = document.createElement('canvas');
	document.body.appendChild(canvas);
	
	// some hotfixes... ( ≖_≖)
	document.body.style.margin = 0;
	canvas.style.position = 'fixed';
	
	// get canvas 2D context and set him correct size
	var ctx = canvas.getContext('2d');
	resize();
	
	// last known position
	var pos = { x: 0, y: 0 };
	
	window.addEventListener('resize', resize);
	document.addEventListener('mousemove', draw);
	document.addEventListener('mousedown', setPosition);
	document.addEventListener('mouseenter', setPosition);
	
	// new position from mouse event
	function setPosition(e) {
	  pos.x = e.clientX;
	  pos.y = e.clientY;
	}
	
	// resize canvas
	function resize() {
	  ctx.canvas.width = window.innerWidth;
	  ctx.canvas.height = window.innerHeight;
	}
	
	function draw(e) {
	  // mouse left button must be pressed
	  if (e.buttons !== 1) return;
	
	  ctx.beginPath(); // begin
	
	  ctx.lineWidth = 5;
	  ctx.lineCap = 'round';
	  ctx.strokeStyle = '#c0392b';
	
	  ctx.moveTo(pos.x, pos.y); // from
	  setPosition(e);
	  ctx.lineTo(pos.x, pos.y); // to
	
	  ctx.stroke(); // draw it!
	}
	function clear(){
		ctx.clear()
	}
	</script>"""
	end;
	cleandraw() = html"""<script>var i;
	for(i of document.getElementsByTagName("canvas")){
	  document.body.removeChild(i);
	}
	</script>""";
	draw(b)= b ? makedraw() : cleandraw();
	html"<style>
main {
    max-width:75%;
    padding: unset;
    margin-right: unset;
    margin-bottom: 20px;
    align-self: center;
}
pluto-helpbox {
    visibility: hidden;
}
</style>"
end

# ╔═╡ 54849fa4-92e0-11eb-0954-f9b2b92707bf
md"# A Concrete Example

Consider a gravitational system of 2 bodies. 

In such a system, the first approximation we apply is that of one being a large body. In doing that, we've reduced the problem from a 2 body system to a 1 body system, which is easy to solve.

But if the sizes are of comparable sizes? Then we find the CoM of the system, say that is stationary, find the reduced masses, and then solve for the 2 bodies independantly.

But what about 3 bodies? Well, we have no way of solving them in the current scope of mathematics."

# ╔═╡ 6621635a-92e3-11eb-20b3-8596a6afae54
md"## Simulations

While we don't have an analytical solution, we can just step through the simulation with a small time step.

1. Let `time` = 0
2. Calculate the force on each particle by the other two as a vector.
3. Multiply the time step with the acceleration to get the change in velocity. 
$\delta v = a*dt$
4. Add the change in velocity to the old velocity. 
$v \leftarrow v + \delta v$
5. Multiply the velocity with the time step to get the change in position.
$\delta x = v*dt$
6. Add the change in position to the old position.
$x \leftarrow x + \delta x$
7. Increment `time` by `dt`
8. Repeat until `time` < `end_time`
9. Plot the path of the 3 bodies
"

# ╔═╡ dc0a1834-92ed-11eb-356d-1b6084e80d83
md"## Optimizations

That code though, is not scalable at all. Anything beyond 10 bodies, it starts struggling. There are multiple ways to make it faster.

### Implementation enhancements

- Parallelization: Probably the easiest way is to parallely calculate the forces and update once.
- Make code staticly typed
- Vectorize
- Force calculation only once for each pair. Create an `Symmetric` matrix
- Keep an eye out for memory

### Hardware

- Use the GPU

### Algorithmic 

- Use a better integration technique, and reduce the number of steps
    - Implicit Euler
    - Runge Kutta, order n, commonly RK4
    - Leapfrog 
- Approximation Optimizations
"

# ╔═╡ 41de6540-92f1-11eb-0011-bb0b6e33f5e1
md"# Approximation Methods"

# ╔═╡ 4fa786f8-932a-11eb-3e41-2b3c2d7732f3
begin
	pts = rand(300), rand(300);
	md"## Radius Clamping"
end

# ╔═╡ 1bc36d42-932a-11eb-15ef-8b088ee8e419
@bind sl Slider(1:2:10, default=1, show_value=true)

# ╔═╡ aa560570-1b2a-4217-a3f4-db46469fdcb5
@bind radius Slider(0:0.01:0.5, default=1, show_value=true)

# ╔═╡ c98b6940-92f9-11eb-1a6d-8bfcda6f3254
let
	_range = range(0, 1; length=sl+1)
	p = scatter(pts[1], pts[2], markersize=5, aspect_ratio=1, xlims=(-0.05, 1.05));
	scatter!(p, [0.5],[0.5], markersize=5);
	vline!(p, _range, color=:brown, width=2)
	hline!(p, _range, color=:brown, width=2)
	plot!(p, radius*cos.(0:0.01:2pi).+0.5, radius*sin.(0:0.01:2pi).+0.5, width=4)
	plot!(p, legend=false)
	q = plot(r->0.007/r^2, -1:0.01:1, ylims=(0,1), xlims=(-0.5,0.5))
	vline!(q, [radius], aspect_ratio=1, size=(600,600))
	plot(p, q)
end

# ╔═╡ 32717a2c-92f9-11eb-3167-356e17b5702b
md"## Barnes-Hut optimization"

# ╔═╡ 596d95cd-5408-4e03-9e18-33a1069d91dd
@bind sl2 Slider(0:10, default=1, show_value=true)

# ╔═╡ d1faed60-20f8-4c79-9819-2d7bf6915b85
let
	radius=0.1;
	_range = range(0, 1; length=(sl2<=1 ? 2+sl2 : 4*(sl2)-3))
	p = scatter(pts[1][1:30], pts[2][1:30], markersize=5, aspect_ratio=1, xlims=(-0.05, 1.05));
	vline!(p, _range, color=:brown, width=2)
	hline!(p, _range, color=:brown, width=2)
	plot!(p, legend=false)
end

# ╔═╡ 843a1ef6-8063-42f2-ace4-06badf5c2b47
md"$1/(r+\epsilon)^2$"

# ╔═╡ c96319f1-eff2-430e-b187-ef6aeb56411c
begin
	plot(x->x^2,0:0.01:10)
	plot!(x->x*log(x), 0:0.01:10)
end

# ╔═╡ Cell order:
# ╟─4ae20254-92ed-11eb-2175-330d93400a78
# ╟─60e719be-92dd-11eb-3ca0-e1a70016febb
# ╟─5c282396-92f3-11eb-26c2-d367635c3b0d
# ╟─7ae2a8f8-9326-11eb-0caf-0d8ff40df358
# ╟─54849fa4-92e0-11eb-0954-f9b2b92707bf
# ╟─6621635a-92e3-11eb-20b3-8596a6afae54
# ╟─dc0a1834-92ed-11eb-356d-1b6084e80d83
# ╟─41de6540-92f1-11eb-0011-bb0b6e33f5e1
# ╠═4fa786f8-932a-11eb-3e41-2b3c2d7732f3
# ╠═1bc36d42-932a-11eb-15ef-8b088ee8e419
# ╠═aa560570-1b2a-4217-a3f4-db46469fdcb5
# ╠═c98b6940-92f9-11eb-1a6d-8bfcda6f3254
# ╟─32717a2c-92f9-11eb-3167-356e17b5702b
# ╠═596d95cd-5408-4e03-9e18-33a1069d91dd
# ╠═d1faed60-20f8-4c79-9819-2d7bf6915b85
# ╠═843a1ef6-8063-42f2-ace4-06badf5c2b47
# ╠═c96319f1-eff2-430e-b187-ef6aeb56411c

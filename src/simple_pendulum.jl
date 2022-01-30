### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ eb826ac2-80ed-11ec-3676-39f76a013595
begin
	using Pkg;
	Pkg.activate()

	using PlutoUI, Plots
end

# ╔═╡ 5c10acf0-1918-4f77-9972-c9edcd0599ba
mutable struct Pendulum
	θ :: Float64 # in radians
	ω :: Float64 # in rad/sec

	l :: Float64 
	mass :: Float64
	radius :: Float64
	anchor :: Vector{Float64}

	traj :: Vector{Float64}
end

# ╔═╡ 76c560fe-d413-4d23-92cf-48be129ef012
get_alpha(obj::Pendulum, g = -9.8) = (g/obj.l) * sin(obj.θ)

# ╔═╡ 65dc9c89-7938-42eb-b130-5641e7913ecb
function update!(obj::Pendulum, Δt::Float64)
	obj.ω +=  Δt * get_alpha(obj)
	obj.θ += Δt * obj.ω # Forward Euler method 

	push!(obj.traj, obj.θ)
end

# ╔═╡ 65c492a4-cb21-4357-a772-fcb96a4feb49
function evolve!(obj::Pendulum, Δt::Float64, num_iter::Int64)
	for time in 1:num_iter
		update!(obj, Δt)
	end
end

# ╔═╡ a985d2e7-bda0-4e3b-9b0e-af414be1d998
function get_pos(obj::Pendulum, n::Int64)
	return [
		obj.anchor[1] + obj.l * sin(obj.traj[n]), 
		obj.anchor[2] - obj.l * cos(obj.traj[n])
	]
end

# ╔═╡ e8880979-0d51-4a0b-8247-8c32db206bbf
function circle(centre::Vector{Float64}, r::Float64)
	theta = range(start = 0., stop = 2π, length = 50)

	xcoords = centre[1] .+ r .* cos.(theta)
	ycoords = centre[2] .+ r .* sin.(theta)
		
	return xcoords, ycoords
end

# ╔═╡ 3a2f5e47-e7f0-44ea-bb99-dd31091ba202
function display(obj::Pendulum, n::Int64, lims::Vector{Float64})
	x, y = get_pos(obj, n)

	# string
	plot(
		[obj.anchor[1], x], 
		[obj.anchor[2], y],
		lw = 2, 
		lc = :black)

	# bob
	plot!(
		circle([x, y], 
		obj.radius), 
		lw = 2, 
		lc = :black, 
		st = :shape, 
		c = :white)

	# anchor
	plot!(
		circle(obj.anchor, obj.radius/8), 
		lw = 2, 
		lc = :black, 
		st = :shape, 
		c = :black)

	# global canvas settings
	plot!(
		aspect_ratio = 1, 
		legend = false, 
		axis = nothing, 
		framestyle = :box,
		xlims = lims[1:2], 
		ylims = lims[3:4]
	)
end

# ╔═╡ c91ef479-681f-4b0a-b832-867ca3bfff22
begin
	dt = 0.005
	nsteps = 1000
	
	object = Pendulum(π/180 * 45., 0., 1., 1., 0.1, [0., 1.], [π/180 * 45.])
	evolve!(object, dt, nsteps)
end 

# ╔═╡ 5a62deae-0219-43ef-b703-37649830ae0c
# display(object, frame_number, [-1.01, 1.01, -0.1, 1.1])

# ╔═╡ 7c536df1-494e-4843-8f47-ebe2b2b4c38d
@bind frame_number Slider(1:2:nsteps)

# ╔═╡ d2f8b2e0-6d70-4103-a1e1-b38f45464131
@gif for frame in 1:3:nsteps
	display(object, frame, [-1.01, 1.01, -0.1, 1.1])
end

# ╔═╡ Cell order:
# ╠═eb826ac2-80ed-11ec-3676-39f76a013595
# ╠═5c10acf0-1918-4f77-9972-c9edcd0599ba
# ╠═76c560fe-d413-4d23-92cf-48be129ef012
# ╠═65dc9c89-7938-42eb-b130-5641e7913ecb
# ╠═65c492a4-cb21-4357-a772-fcb96a4feb49
# ╠═a985d2e7-bda0-4e3b-9b0e-af414be1d998
# ╠═e8880979-0d51-4a0b-8247-8c32db206bbf
# ╠═3a2f5e47-e7f0-44ea-bb99-dd31091ba202
# ╠═c91ef479-681f-4b0a-b832-867ca3bfff22
# ╠═5a62deae-0219-43ef-b703-37649830ae0c
# ╠═7c536df1-494e-4843-8f47-ebe2b2b4c38d
# ╠═d2f8b2e0-6d70-4103-a1e1-b38f45464131

### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

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

# ╔═╡ 68a746e3-a9bc-4f86-9f32-ae0f99b77198
function get_alpha(obj::Pendulum, g = -9.8)
	return (g/obj.l) * sin(obj.θ)
end

# ╔═╡ 65dc9c89-7938-42eb-b130-5641e7913ecb
function update!(obj::Pendulum, Δt::Float64)
	obj.ω += Δt * get_alpha(obj)
	obj.θ += Δt * obj.ω

	push!(obj.traj, obj.θ)
end

# ╔═╡ 65c492a4-cb21-4357-a772-fcb96a4feb49
function evolve!(obj::Pendulum, Δt::Float64, num_iter::Int64)
	for time in 1:num_iter
		update!(obj, Δt)
	end
end

# ╔═╡ b841b858-fbbf-443d-b965-bc13cdde442c
begin
	object = Pendulum(π/180 * 45., 0., 1., 1., 0.1, [0., 1.], [π/180 * 45.])
	evolve!(object, 0.01, 10)
end 

# ╔═╡ Cell order:
# ╠═eb826ac2-80ed-11ec-3676-39f76a013595
# ╠═5c10acf0-1918-4f77-9972-c9edcd0599ba
# ╠═68a746e3-a9bc-4f86-9f32-ae0f99b77198
# ╠═65dc9c89-7938-42eb-b130-5641e7913ecb
# ╠═65c492a4-cb21-4357-a772-fcb96a4feb49
# ╠═b841b858-fbbf-443d-b965-bc13cdde442c

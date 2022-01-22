### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b7f93ae2-8e0b-11eb-3242-497053d4e1d6
using LinearAlgebra

# ╔═╡ ede52d90-8e0c-11eb-0b12-d98b358c9bc9
using Plots

# ╔═╡ ee832bb8-8e06-11eb-09c6-0b14f4966f83
md"# Walker on a strip"

# ╔═╡ a3ffa1b6-8e06-11eb-1d16-3939fbd1448b
md"
Assume the probability of the walker being on some x be denoted by an array called the state vector, denoted by $\ket{\psi}$
"

# ╔═╡ e11703aa-8e06-11eb-3cce-ada7bb452b9e
ψ = zeros(Float64, 100); ψ[50] = 1; ψ

# ╔═╡ f671e92c-8e06-11eb-3252-3b436625c88b
md"Further, every **step** basically shifts around the probability. Assume that the probability of a particle jumping left is $p_l$, jumping right is $p_r$, staying is $p_c = 1-p_r-p_c$. Then, the probability of particle in x at t is

$$\rho(x,t) = \rho(x-1, t-1)\cdot p_r + \rho(x+1, t-1)\cdot p_l + \rho(x, t-1) \cdot p_c$$

"

# ╔═╡ 4905788c-8e07-11eb-3121-93fd852ae92b
md"Another way to look at this is to see influx and outflux.

$$\Delta \rho(x,t) = \rho(x-1, t-1)\cdot p_r + \rho(x+1, t-1)\cdot p_l 
- \rho(x, t-1) \cdot p_r - \rho(x, t-1) \cdot p_l$$
$$
\begin{align}
\rho(x,t) =& \Delta \rho(x,t) + \rho(x, t-1)\\
\rho(x,t) =& \rho(x-1, t-1)\cdot p_r + \rho(x+1, t-1)\cdot p_l \\
&- \rho(x, t-1) \cdot p_r - \rho(x, t-1) \cdot p_l + \rho(x, t-1)\\
=& \rho(x-1, t-1)\cdot p_r + \rho(x+1, t-1)\cdot p_l \\
&+(1-p_r-p_l)\rho(x, t-1)\\
=&\rho(x-1, t-1)\cdot p_r + \rho(x+1, t-1)\cdot p_l
+\rho(x, t-1)\cdot p_c
\end{align}$$

"

# ╔═╡ 3ade0012-8e09-11eb-24c9-95ccd89bf11d
md"Now this dynamics has a very important property. It is memoryless. It doesn't matter _how_ we got there, but the previous step determines the next. Mathematically, this means, 

$$\mathcal M^{s+t}\ket{\psi} = (\mathcal M^t\circ\mathcal M^s)\ket{\psi}$$

such maps are called Markovian maps and they can be represented as a single matrix operation on the state vector.
"

# ╔═╡ 443face0-8e0a-11eb-0040-579b66cc266f
md"Explicitly, the matrix is 
$$\begin{bmatrix}
p_c&p_l&.&.&\dots\\
p_r&p_c&p_l&.&\dots\\
.&p_r&p_c&p_l&\dots\\
\vdots&\vdots&\vdots&\vdots&\ddots\\
\end{bmatrix}$$"

# ╔═╡ 5830d2e8-8e36-11eb-22ac-4f194c943573
md"$$x_i(t+1) = [pru, pcu, plu; 
                 prc, pcc, plc;
                                ] * [x_{i-1, j-1}, x_{i, j-1}, x_{i+1, j+1};
                                               ]$$"

# ╔═╡ ccd86fd2-8e0b-11eb-173c-c9aafc16fd48
M(pl, pr, n) = Tridiagonal(fill(pr, n-1), fill(1-pr-pl, n), fill(pl, n-1))

# ╔═╡ 0b9f7058-8e0c-11eb-1833-276f822d181b
M(0.1, 0.1, 5)^3

# ╔═╡ 4cc82600-8e0d-11eb-3a03-c3f236b1dbda
let
	ψ = zeros(Float64, 100)
	ψ[50] = 1
	m = M(0.1, 0.1, 100)
	@gif for i in 1:50
		ψ .= m*ψ
		plot(-50:49, ψ, ylims=(0,1))
	end
end

# ╔═╡ c98957c0-8e0d-11eb-3c4a-95bc1a4bc0f0
let
	n = 100
	xs = 49
	ψ = zeros(Float64, xs); ψ[floor(Int, (xs+1)/2)] = n; ψ
	m = M(0.4, 0.1, xs)
	q = plot([0], [n], ylims=(0,1.5*n))
	a = @animate for i in 1:150
		ψ .= m*ψ
		p=plot(-floor((xs-1)/2):floor((xs-1)/2), ψ, ylims=(0,n))
		push!(q[1][1], sum(ψ))
		plot(p,q, layout=(2,1))
	end
	gif(a)
end

# ╔═╡ c19cb0ee-8e0e-11eb-35ff-b97633689dff
let
	ψ = zeros(Float64, 99); ψ[50] = 100; ψ
	m = M(0.3, 0.3, 99)
	q = plot([0], [100], ylims=(0,120))
	a = @animate for i in 1:50
		ψ .= round.(m*ψ)
		p=plot(-49:49, ψ, ylims=(0,50))
		push!(q[1][1], sum(ψ))
		plot(p,q, layout=(2,1))
	end
	gif(a)
end

# ╔═╡ 359ba39c-8e14-11eb-3e15-eb12b8ef1c22
let
	ψ = zeros(Float64, 99); ψ[[46,54]] .= 75; ψ
	m = M(0.3, 0.3, 99)
	q = plot([0], [150], ylims=(0,170))
	a = @animate for i in 1:100
		ψ .= round.(m*ψ)
		p=plot(-49:49, ψ, ylims=(0,50))
		push!(q[1][1], sum(ψ))
		plot(p,q, layout=(2,1))
	end
	gif(a)
end

# ╔═╡ Cell order:
# ╟─ee832bb8-8e06-11eb-09c6-0b14f4966f83
# ╟─a3ffa1b6-8e06-11eb-1d16-3939fbd1448b
# ╠═e11703aa-8e06-11eb-3cce-ada7bb452b9e
# ╟─f671e92c-8e06-11eb-3252-3b436625c88b
# ╟─4905788c-8e07-11eb-3121-93fd852ae92b
# ╟─3ade0012-8e09-11eb-24c9-95ccd89bf11d
# ╟─443face0-8e0a-11eb-0040-579b66cc266f
# ╠═5830d2e8-8e36-11eb-22ac-4f194c943573
# ╠═b7f93ae2-8e0b-11eb-3242-497053d4e1d6
# ╠═ccd86fd2-8e0b-11eb-173c-c9aafc16fd48
# ╠═0b9f7058-8e0c-11eb-1833-276f822d181b
# ╠═ede52d90-8e0c-11eb-0b12-d98b358c9bc9
# ╠═4cc82600-8e0d-11eb-3a03-c3f236b1dbda
# ╠═c98957c0-8e0d-11eb-3c4a-95bc1a4bc0f0
# ╠═c19cb0ee-8e0e-11eb-35ff-b97633689dff
# ╠═359ba39c-8e14-11eb-3e15-eb12b8ef1c22

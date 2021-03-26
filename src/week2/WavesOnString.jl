### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b74555c2-8e1d-11eb-2b56-a7f7f4466824
begin
	using Plots
	using SparseArrays
end

# ╔═╡ 7902c5f4-8e21-11eb-0178-7763b7325882
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

# ╔═╡ cc8dc632-8e1d-11eb-0cf3-23084c26714f
function initCond(xgrid, sType)
	
    if(sType == 1)
        y = 1/(sqrt(2*pi)) * exp.(xgrid .^ 2 ./ (-2)) #gaussian pluck in center
    
	elseif(sType == 2) 
		y = 0.25*sin.(3*xgrid * (pi/xgrid[end-1])) #standing sinusoidal wave
    end 
    
    return (copy(y), copy(y))
end

# ╔═╡ f5f68036-8e1d-11eb-09ad-c94793b523e9
md"""
# Wave Equation
$$\frac{\partial^2 y(x,t)}{\partial t^2} = c^2 \frac{\partial^2 y(x,t)}{\partial x^2}$$
"""

# ╔═╡ 225594dc-8e1e-11eb-01f6-bb4ffd5c8f53
md"""
## Finite Difference
$$\frac{y_i^{j+1} - 2y_i^j + y_i^{j-1}}{(\Delta t)^2} = c^2 \frac{y_{i+1}^j - 2y_i^j + y_{i-1}^j}{(\Delta x)^2}$$

Let $\alpha = \left (\frac{c\Delta t}{\Delta x} \right)^2$ ;

$$y_i^{j+1} = \bigg [ \alpha y_{i+1}^j + 2(1-\alpha)y_i^j + \alpha y_{i-1}^j \bigg ] - y_i^{j-1}$$
"""

# ╔═╡ 018f8de2-8e1f-11eb-05e0-afcb09ae07b5
md"""
### Matrix form
$$\vec{y}^{j+1} = M\cdot \vec{y}^{j} - \vec{y}^{j-1}$$

$$M = \begin{pmatrix}
2(1-\alpha) & \alpha & 0 & . & . & . & .\\
\alpha & 2(1-\alpha) & \alpha & 0 & . & . & .\\
0 & \alpha & 2(1-\alpha) & \alpha & 0 & . & .\\
. & . & . & . & . & . & .\\
. & . & . & . & . & . & .\\
. & . & 0 & \alpha & 2(1-\alpha) & \alpha & 0\\
. & . & . & 0 & \alpha & 2(1-\alpha) & \alpha\\
. & . & . & . & 0 & \alpha & 2(1-\alpha) &
\end{pmatrix}$$

"""

# ╔═╡ f2cd104c-8e3f-11eb-022b-471266870ec0
md"""
### Single string
"""

# ╔═╡ 9fbfd9b0-8e40-11eb-3d00-85ef71f19778
md"""
- n :: Number of points in discrete spatial grid
- xi :: Initial co-ordinate value in grid
- xf :: Final co-ordinate value in grid
- m :: Number of timesteps
- dt :: Size of each time step
- c :: Speed of wave in string 
"""

# ╔═╡ cc8d8e62-8e1d-11eb-0f06-85dbd047a8f3
function waveEquation(n::Int64, xi::Float64, xf::Float64, m::Int64, dt::Float64, c::Float64)
    y = zeros(Float64, (n, m)) #height of string at each point in space (n) and time (m)
    
    dx = (xf-xi)/n #spacing of discrete grid
    xgrid = collect(xi:dx:(xf-dx)) #discretized spatial grid
    
    #CREATING EVOLUTION MATRIX
    α = (c*dt/dx)^2 
    M = SparseArrays.spdiagm(-1 => α*ones(n-1), 0 => 2(1-α)*ones(n), 1 => α*ones(n-1))
    
    #INITIAL CONDITIONS
    y[:, 1], y[:, 2] = initCond(xgrid, 1)
    
	#TIME EVOLUTION LOOP
    for j in 2:(m-1)
        y[:, j+1] = M * y[:, j] - y[:, j-1] 
        
		#SOURCE TERMS
		#y[1, j+1] = 0.1*sin(5*j*dt) #sinusoidal driving source
        #y[1, j+1] = 0.125 * exp((j*dt - 2)^2/ (-2*0.1)) #single gaussian pulse
		
		#BOUNDARY CONDITION
		#y[n, j+1] = y[n-1, j+1] #open end
    end
    
    #GIF CREATION
    anim = @gif for j in 1:5:m
       plot(xgrid, y[:, j], ylim = (-0.3, 0.3)) 
    end
    
    return anim
end

# ╔═╡ 86e6571c-8e3f-11eb-0d4a-fdaba3acd1d6
md"""
This code was written hastily, so it does not elegantly accomodate initial/boundary conditions and source terms.

You can however uncomment the specific lines above and run the function call below manually to switch between them.

"""

# ╔═╡ f1f54154-8e1d-11eb-1f4a-cd0485803c3b
@time waveEquation(200, -10.0, 10.0, 1000, 0.01, 3.0)

# ╔═╡ 5902b696-8e22-11eb-15b9-bbe17268f151
md"""

### Composite string
"""

# ╔═╡ 38d6d37a-8e40-11eb-2d13-119451e978f3
md"""
- n :: Number of points in discrete spatial grid
- xi :: Initial co-ordinate value in grid
- xf :: Final co-ordinate value in grid
- m :: Number of timesteps
- dt :: Size of each time step
- c1 :: Speed of wave in string 1
- c2 :: Speed of wave in string 2
"""

# ╔═╡ 23b5f870-8e22-11eb-1d73-0fdffd260a34
function waveEquationComposite(n::Int64, xi::Float64, xf::Float64, m::Int64, dt::Float64, c1::Float64, c2::Float64)
    y = zeros(Float64, (n, m)) #height of string at each point in space (n) and time (m)
    
    dx = (xf-xi)/n #spacing of discrete grid
    xgrid = collect(xi:dx:(xf-dx))  #discretized spatial grid
    
	#CREATING EVOLUTION MATRIX
    α = (c1*dt/dx)^2
    β = (c2*dt/dx)^2
    
    nmid = n÷2
    M1 = SparseArrays.spdiagm(-1 => α*ones(nmid-1), 0 => 2(1-α)*ones(nmid), 1 => α*ones(nmid-1))
    M2 = SparseArrays.spdiagm(-1 => β*ones(nmid-1), 0 => 2(1-β)*ones(nmid), 1 => β*ones(nmid-1))
    M = SparseArrays.blockdiag(M1, M2)
    M[nmid, nmid + 1] = α
    M[nmid + 1, nmid] = β
    
	#INITIAL CONDITIONS
    #y[:, 1], y[:, 2] = initCond(xgrid, 1)
    
	#TIME EVOLUTION LOOP
    for j in 2:(m-1)
        y[:, j+1] = M * y[:, j] - y[:, j-1] 
        
		#SOURCE TERMS
		#y[1, j+1] = 0.1*sin(5*j*dt) #sinusoidal driving source
        y[1, j+1] = 0.125 * exp((j*dt - 2)^2/ (-2*0.1)) #single gaussian pulse
		
		#BOUNDARY CONDITION
		#y[n, j+1] = y[n-1, j+1] #open end
    end
	
	#GIF CREATION
    anim = @gif for j in 1:5:m
        plot(xgrid[1:nmid], y[1:nmid, j], ylim = (-0.3, 0.3))
        plot!(xgrid[nmid:end], y[nmid:end, j], ylim = (-0.3, 0.3), lw = 2)
    end
    
    return anim
end

# ╔═╡ 4e5c9fea-8e22-11eb-31fe-4f15408b18dd
waveEquationComposite(200, -10.0, 10.0, 1000, 0.01, 3.0, 5.0)

# ╔═╡ Cell order:
# ╟─7902c5f4-8e21-11eb-0178-7763b7325882
# ╠═b74555c2-8e1d-11eb-2b56-a7f7f4466824
# ╠═cc8dc632-8e1d-11eb-0cf3-23084c26714f
# ╟─f5f68036-8e1d-11eb-09ad-c94793b523e9
# ╟─225594dc-8e1e-11eb-01f6-bb4ffd5c8f53
# ╟─018f8de2-8e1f-11eb-05e0-afcb09ae07b5
# ╟─f2cd104c-8e3f-11eb-022b-471266870ec0
# ╟─9fbfd9b0-8e40-11eb-3d00-85ef71f19778
# ╠═cc8d8e62-8e1d-11eb-0f06-85dbd047a8f3
# ╟─86e6571c-8e3f-11eb-0d4a-fdaba3acd1d6
# ╠═f1f54154-8e1d-11eb-1f4a-cd0485803c3b
# ╟─5902b696-8e22-11eb-15b9-bbe17268f151
# ╟─38d6d37a-8e40-11eb-2d13-119451e978f3
# ╠═23b5f870-8e22-11eb-1d73-0fdffd260a34
# ╠═4e5c9fea-8e22-11eb-31fe-4f15408b18dd

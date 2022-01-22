### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ cb892de0-875f-11eb-0ac1-6366b65d12e1
begin
	struct Hidden
		summary
		content
	end
	Base.show(io::IO, m::MIME"text/html", h::Hidden) = show(io, m, HTML("""<details><summary><h3>$(h.summary)</h3></summary>$(html(md"#### Giving up so quick?

Don't! Try a bit longer! No? Ok.

"))$(html(h.content))</details>"""))
end

# ╔═╡ 043c0ff2-86ea-11eb-12c4-51ccab1453f5
md"# Random walks and diffusion"

# ╔═╡ 8013305e-86ec-11eb-380b-99016b60135e
md"###### The diffusion equation is a partial differential equation which describes density fluc-tuations in a material undergoing diffusion. The equation can be written as:
$$\frac{\partial \phi(\vec{r}, t)}{\partial t} = D \nabla^2\phi(\vec{r}, t)$$

where $\phi(\vec{r}, t)$ is the density of the diffusing material at location $\vec{r} = (x,y,z)$ and time $t$. $D$ denotes the collective diffusion coefficient for density $\phi(\vec{r}, t)$ at location $\vec{r}$. The above equation is a simplified case wherein the diffusion co-efficient $D$ is constant throughout space.

"

# ╔═╡ 233674b0-86ef-11eb-1076-1b3c74102904
md" #### A seemingly unrelated process: Random walks"

# ╔═╡ 82cb8d90-86ed-11eb-256a-b5ab5f8c886f
md"This is a stochastic process where we have a particle on an _infinite discrete_ grid, say a 1-dimensional line. Think a drunkard walking. Each moment, it can move one step to the right or one step to the left, with some probabilities $p$ and $1-p$.  **The particle has no 'memory' of previous choices, so every moment it makes an independent decision**.
At the end of N _timesteps_, the particle would end up at some random point on the grid. 

![Random walk](https://www.mit.edu/~kardar/teaching/projects/chemotaxis(AndreaSchmidt)/numberline_hops.gif)"


# ╔═╡ bf72af32-875b-11eb-09ad-89156f89dfce
md"Monitoring such individual particles may not tell us much, but when we perform this for many many particles and plot the distribution of final positions… then there is something interesting going on there. Try out the following stuff:

* (**1-Dimensional**) Set various values of p and find the mean/variance of the distribution. What does this distribution converge to as you increase the number of particles? Can you come up with the exact distribution using theoretical calculations and verify the results. (**place all particles initially at origin, and run for 1000 timesteps**)


* (**2-Dimensional**) There are now four probabilities which we can play around with (4 directions to move). Set all probabilities equal to 0.25, and obtain the distribution. Change the number of timesteps N, and plot how the distribution changes wrt. N"

# ╔═╡ 362078c0-8760-11eb-02b6-8955248f55f7
Hidden("Coding Hints", md"""
#### Steps for 1D
1. Set x as 0
2. Generate a random number from 0-1
3. Check if number is less than p (WHY?)
3. If yes, add 1 to x. Otherwise subtract 1 (WHY?)
4. repeat from step 2 1000 times
5. record x in an array
6. repeat from step 1 100 times

Can you optimize this?

#### Steps for 2D
1. Haha, no. No solution for 2D. Try generalizing from 1D yourself
""")

# ╔═╡ ce913a90-875b-11eb-1eaf-9fe615fc91de
md"If we interpret the number of timesteps as a discrete version of time, this is actually quite similar to the spread obtained via the diffusion of a drop of non-viscous fluid placed at a single point on a surface. Is there some connection between a random walk and diffusion processes?

![Diffusion](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4BdPl1ArKY55A_BaQGtHUlQKsFOzY_kPyEw&usqp=CAU)

!!! danger \"Main idea\"
    We can discretize space and time, and get more accurate results as we make the grid mesh finer and finer. Perhaps this is the missing link.

Perform the calculations to show that this unbiased (equal probabilities) random walk has a distribution that emulates the diffusion process in the limit of large number of particles. (Assume that the diffusion equation mentioned above is characteristic of an isotropic diffusion process. Or look up how we get that equation in the first place and convince yourself.) 

!!! tips \"Hint\"
    Random walks are markov chains and first order finite differences may be useful in discrete grids.)

!!! warning \"Biased walks\"
    What happens in a biased random walk? Can it still resemble some diffusion process?"

# ╔═╡ 59015eb8-86f2-11eb-06be-5de443d037d9
md"# Waves and strings


"

# ╔═╡ 90b5c8f4-8700-11eb-273b-8df26a846f18
md"The equation governing the evolution of a transverse waves on a 1D string is given by:

$$\frac{\partial^2 y(x,t)}{\partial t^2} = \frac{T}{\mu} \frac{\partial^2 y(x,t)}{\partial x^2}$$

Theoretically, we already know that we can have solutions of the form $y(x-vt)$ where the wave travels with velocity $v = \sqrt{\frac{T}{\mu}}$. How can we simulate the evolution of a transverse wave on a computer? "

# ╔═╡ 98ba16a0-875e-11eb-24c9-8b3690272caa
md"The most basic idea could be to divide the string into closely spaced discrete points (spaced $dx$ apart), and store the value $y(x,t)$ at each of these points. 

$$x \equiv \{x_0, x_0 + dx, ..., x_0 + (n-1)dx \}$$

$$t \equiv \{t_0, t_0 + dt, ..., t_0 + (m-1)dt \}$$

$$\text{1st order finite difference: }\frac{dy(x)}{dx}\bigg|_{x = x_i} \equiv \frac{y(x_i) - y(x_{i-1})}{dx}$$

To obtain the evolution of $y(x, t)$ for this discrete set of points, you can use the method of finite differences to approximate the two double derivatives. This will result in a recursive equation which allows us to find the updated $y$ values using the previous timesteps' $y$ values.
!!! note
    It might be useful to cast it as a matrix equation and use linear algebra to solve it"


# ╔═╡ 2f26dc00-8763-11eb-386a-f18e57d67e99
Hidden("Coding Hints",md"
At each instant, each point (particle) on the string is characterized by its height $y$. The information of velocity is contained in the neighbouring points (approximate derivatives). So you only need to store an array of the heights $y$.
	
* Use the method of finite differences and discretize the wave equation. This will give you a way to directly obtain the heights $y$ in the next time step: (find this function $f$)
	
$y(x_i, t_{i+1}) = f(y(x_{i-1}, t_i), y(x_i, t_i), y(x_{i+1}, t_i))$

* Now you can simply iterate through each $x_i$ and update the values of $y$ using the values of $y$ in the previous timestep. (The smarter and quicker way would be to somehow cast this as a matrix equation and use linear-algebra subroutines.)
")


# ╔═╡ a5223492-875e-11eb-1514-6b2266f4949b
md"Using this, try the following:
- Simulate reflection from open and closed boundaries. Answering the question _\"What is a boundary?\"_ may help.
- Connect strings of two different $\mu$ and measure reflected/transmitted amplitude ratios and verify with theoretical results. 
- Try to setup standing waves by sending equal amplitude/frequency waves travelling in opposite directions
- Test the limits of this implementation; how fine must the discretization of space and time be so that we get reasonable situations? Is there a maximum wave velocity $v$ that we can simulate accurately for a given discretization ($dx$ and $dt$)?"

# ╔═╡ Cell order:
# ╟─cb892de0-875f-11eb-0ac1-6366b65d12e1
# ╟─043c0ff2-86ea-11eb-12c4-51ccab1453f5
# ╟─8013305e-86ec-11eb-380b-99016b60135e
# ╟─233674b0-86ef-11eb-1076-1b3c74102904
# ╟─82cb8d90-86ed-11eb-256a-b5ab5f8c886f
# ╟─bf72af32-875b-11eb-09ad-89156f89dfce
# ╟─362078c0-8760-11eb-02b6-8955248f55f7
# ╟─ce913a90-875b-11eb-1eaf-9fe615fc91de
# ╟─59015eb8-86f2-11eb-06be-5de443d037d9
# ╟─90b5c8f4-8700-11eb-273b-8df26a846f18
# ╟─98ba16a0-875e-11eb-24c9-8b3690272caa
# ╟─2f26dc00-8763-11eb-386a-f18e57d67e99
# ╟─a5223492-875e-11eb-1514-6b2266f4949b

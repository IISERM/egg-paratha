
# Tentative plan for the event

## Level 1:
Goal is to visualize and play around with familiar concepts in physics using the computer as a tool. Some ideas used in research based computational physics can be touched upon, but the topics are simple and exploration based, more reminiscent of physics-based game engines. 

### Sessions:
- (Euler integration) -> Simple pendulum 
    - **Progression:** Add drag/damping forces; Add external driving; Try to observe resonance. 
    - **Explore:** Higher order integration schemes

- (Euler integration, Primitive Collision detection) -> Billiard Balls
    - **Progression:** Create a Scene with bouncing balls under gravity; incorporate friction, energy losses upon bouncing, etc. 
    - **Explore:** Event-driven approach (alternative to brute integration)

- (Velocity-Verlet integration (?), Intro/Necessity of symplectic solvers) -> n-body gravity
    - **Progression:** Write the code so it is extensible to add other properties; e.g. Electric charge.
    - **Explore:** Optimization schemes for large # of objects, Application in MolDyn. 

- (Basic) -> Visualize electric field due to distribution of fixed point charges. 
    - **Progression:** Given the functional values of electric field at a grid of coordinates, plot equipotential surfaces. (Marching Squares, contouring algorithm)
    - **Explore:** How to extend this for an arbitrary continuous charge distribution?

- (RK4 integration, maybe a bit of sympy) -> Double Pendulum 
    - **Progression:** Extend to arbitrarily many pendula; Simulate an actual rope (which can get slack, unlike Simple Pendulum) by modelling it as a large collection of coupled pendula. 
    - **Explore:** How to model rigid bodies with arbitrary constraints? (without hard-coding every such property)

- (Euler integration) -> Simple pendulum but with springs instead of rigid rods. 
    - **Progression:** Extend to arbitrary number of objects and springs. Incorporate basic collision system to make primitive model of soft bodies.
    - **Explore:** NA

- (??) -> Visualize electric field due to accelerating point charge(s).

### Projects/DIY:
- (Ray-tracing) -> 2D setup; light rays interacting with mirrors and lenses
    - **Progression:** NA
    - **Explore:** Extend to 3D.

- (??) -> Code a setup to specify and simulate arbitrary electric circuits to solve for current, voltage, etc. (in-house version of SPICE)
    - **Progression:** NA
    - **Explore:** NA

## Level 2:

**TBA.**

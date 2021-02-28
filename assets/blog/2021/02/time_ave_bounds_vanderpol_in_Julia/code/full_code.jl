# Title: Computing time average bounds for the Van der Pol oscillator in Julia
# Publication date: 22 February 2021
# Last modified: February 28, 2021
# Code from https://rmsrosa.github.io/blog/2021/02/time_ave_bounds_vanderpol_in_Julia/

# Code snippet: vanderpolsolt.jl
# This file was generated, do not modify it. # hide
using PlotlyJS
using DifferentialEquations
use_style!(:ggplot)

function vdp_du(du,u,params,t)
    x, y = u
    μ, = params
    dx = y
    dy = μ*(1 - x^2)*y - x
    du .= [dx, dy]
end

u0 = [4.0, 6.0]
Tmax = 80.0
tspan=(0.0,Tmax)

μ_range=(0.2,1.0,2.0,4.0)

vdp_sol = [DifferentialEquations.solve(ODEProblem(vdp_du,u0,tspan,[μ], saveat=0.0:0.1:Tmax)) for μ in μ_range]

vdp_sol_times = 0.0:0.1:Tmax

plt_mu = [
    PlotlyJS.plot(
        [PlotlyJS.scatter(;x=vdp_sol_times, y=map(u->u[1], vdp_sol[j].(vdp_sol_times)), line_width=1, name="dx(t)/dt", showlegend=true*(j==1), mode="lines", line_color="orange"),
        PlotlyJS.scatter(;x=vdp_sol_times, y=map(u->u[2], vdp_sol[j].(vdp_sol_times)), line_width=3, name="x(t)", showlegend=true*(j==1),mode="lines", line_color="steelblue")],
        Layout(;xaxis_title = "t", yaxis_range=[-7.0,7.0], title="μ=$(μ_range[j])")
        )
    for j in 1:length(μ_range)
    ]

plt_comb = [plt_mu[1] plt_mu[2]; plt_mu[3] plt_mu[4]]

# display(plt_comb) # hide - for VSCode or the REPL 
fdplotly(json(plt_comb), style="width:680px;height:500px") # hide - for Franklin

# Code snippet: vanderpolphasesp.jl
# This file was generated, do not modify it. # hide
plt_phsp = [
    PlotlyJS.Plot(
        PlotlyJS.scatter(;x=map(u->u[1], vdp_sol[j].(vdp_sol_times)), y=map(u->u[2], vdp_sol[j].(vdp_sol_times)), line_width=2, name="(x(⋅),y(⋅))", showlegend=true*(j==1), mode="lines", line_color="steelblue"),
        Layout(;xaxis_title = "x", yaxis_title = "y", xaxis_range=[-7.0,7.0],yaxis_range=[-7.0,7.0], title="Phase portrait μ=$(μ_range[j])")
    )
    for j in (1:3:4)
]

plt_ps = [plt_phsp[1] plt_phsp[end]]
# display(plt_ps) # hide - for VSCode or the REPL 
fdplotly(json(plt_ps), style="width:680px;height:350px") # hide - for Franklin

# Code snippet: timeintegration.jl
# This file was generated, do not modify it. # hide
using QuadGK

μ=4.0
u0 = [4.0, 6.0]
Tmax = 5000.0

ϕ(u) = sum(u.^2)

function get_means_vdp(u0, μ, ϕ, Tmax)
    tspan=(0.0,Tmax)

    vdp_sol_long = DifferentialEquations.solve(ODEProblem(vdp_du,u0,tspan,[μ]))

    ϕ_times = Tmax/100:Tmax/100:Tmax
    ϕ_mean_partialsums = [quadgk(t -> ϕ(vdp_sol_long(t)), j == 1 ? 0 : ϕ_times[j-1], ϕ_times[j], rtol=1e-8)[1] for j in 1:length(ϕ_times)]
    ϕ_mean = [sum(ϕ_mean_partialsums[1:n])/ϕ_times[n] for n = 1:length(ϕ_times)]
    return ϕ_times, ϕ_mean
end

ϕ_times, ϕ_mean = get_means_vdp(u0, μ, ϕ, Tmax)

plt_int = PlotlyJS.plot(
    PlotlyJS.scatter(;x=ϕ_times, y=ϕ_mean, line_width=2, name="ϕ_mean(T)", mode="lines", line_color="red"),
    Layout(;yaxis_range=[4.0,8.0], xaxis_title = "T", yaxis_title = "x²+y²", title="Evolution of the time average ϕᵤ(T) = (1/T)∫₀ᵀ ‖u(t)‖² dt;\nbound Φ̄ ≤ $(round(ϕ_mean[end],digits=3))"
    )
)

# display(plt_int) # hide - for VSCode or the REPL 
fdplotly(json(plt_int), style="width:680px;height:350px") # hide - for Franklin

# Code snippet: sosvdp.jl
# This file was generated, do not modify it. # hide
using DynamicPolynomials
using SumOfSquares
using SDPAFamily

function get_bound_vdp_sos(μ, ϕ, Vdeg)
    @polyvar x y

    f = [y, μ*(1 - x^2)*y - x]

    u = [x, y]
    X = monomials([x, y], 1:Vdeg)

    solver = optimizer_with_attributes(SDPAFamily.Optimizer{Float64}, MOI.Silent() => true)
    model = SOSModel(solver)

    @variable(model, V, Poly(X))

    @variable(model, γ)
    # set_start_value(γ, 6.0) # MathOptInterface VariablePrimalStart() is not supported with SDPAFamily.Optimizer{Float64}

    dVdt  = sum(differentiate(V, u) .* f) 

    @constraint(model, γ - ϕ(u) - dVdt >= 0)

    @objective(model, Min, γ)

    JuMP.optimize!(model)

    return V, objective_value(model)
end

μ=4
ϕ(u) = sum(u.^2)
Vdeg_range = 4:2:10
optim = [get_bound_vdp_sos(μ, ϕ, Vdeg) for Vdeg in Vdeg_range]

bounds = [optim[j][end] for j in 1:length(optim)]

plt_sos = PlotlyJS.plot(
    PlotlyJS.scatter(;x=Vdeg_range[2:end], y=bounds[2:end], yaxis_log=true, line_width=2, name="bound", mode="lines+markers", line_color="green"),
    Layout(;yaxis_range=[4.0,6.0], xaxis_title = "degree of auxiliary polynomial V", yaxis_title = "bound", title="Bounds on Φ̄ for different degrees for V"
    )
)

# Code snippet: sosvdpboundtable.jl
# This file was generated, do not modify it. # hide
#hideall
using PrettyTables

formatter = (v,i,j) -> j == 1 ? Int(v) : round(v, digits=3)
# pretty_table(hcat(Vdeg_range, bounds), ["degree" "bound"], header_crayon=crayon"yellow bold", formatters=formatter) # hide - - for VSCode or the REPL, instead of the following
io = IOBuffer()
pretty_table(io, hcat(Vdeg_range, bounds), ["degree" "bound"], backend=:html, standalone=false, formatters=formatter)
println("~~~", String(take!(io)), "~~~")

# Code snippet: sosvdpbounds.jl
# This file was generated, do not modify it. # hide
#hideall
# display(plt_sos) # hide - for VSCode or the REPL 
fdplotly(json(plt_sos), style="width:680px;height:350px") # hide - for Franklin

# Code snippet: vdpVaux.jl
# This file was generated, do not modify it. # hide
Tmax = 50.0
vdp_sol_times = 0.0:0.01:Tmax
plt_composite = []
for j=1:length(optim)
    xmesh = -4.2:0.2/j:4.2;
    ymesh = -10:0.2/(j+2):10;
    xgrid = fill(1,length(ymesh))*xmesh';
    ygrid = ymesh*fill(1,length(xmesh))';
    V = optim[j][1]
    Vmin = minimum([value(V)(x,y) for x in xmesh for y in ymesh])
    v(x,y) = log(1 + value(V)(x,y) - Vmin)
    vdp_sol_x = map(u->u[1], vdp_sol[end].(vdp_sol_times))
    vdp_sol_y = map(u->u[2], vdp_sol[end].(vdp_sol_times))
    vgrid = v.(xgrid,ygrid)
    tracesurf = PlotlyJS.scatter(;x=xgrid, y=ygrid, z = vgrid, type="surface", name="auxiliary function")
    traceline0 = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=0.0*vdp_sol_x, line_width=6, line_color="orange", mode="lines", type="scatter3d", name="orbit")
    tracelinevxy = PlotlyJS.scatter(;x=vdp_sol_x, y=vdp_sol_y, z=v.(vdp_sol_x,vdp_sol_y), line_width=6, line_color="green", mode="lines", type="scatter3d", name="lifted orbit")
    push!(plt_composite, PlotlyJS.Plot([tracesurf,traceline0,tracelinevxy], Layout(;xaxis_title = "x", yaxis_title = "y", zaxis_title="z=ln(1+V-min(V))", legend_x=0.0, legend_y=1.0, title="Auxiliary function V=V(x,y) with degree m=$(Vdeg_range[j]) and bound $(round(bounds[j],digits=3))")))
end
nothing # hide - needed not to show anything with \show{vdpVaux}

# Code snippet: sosvdpVplots.jl
# This file was generated, do not modify it. # hide
#hideall
for j=(1,2,4)
    # display(plt_composite[j]) # hide - for VSCode or the REPL 
    fdplotly(json(plt_composite[j]), style="width:680px;height:350px") # hide - for Franklin
end
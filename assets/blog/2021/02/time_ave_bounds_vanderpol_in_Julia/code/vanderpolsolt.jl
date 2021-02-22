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
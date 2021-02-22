# This file was generated, do not modify it. # hide
#hideall
using PlotlyJS
using Interact
using DifferentialEquations
use_style!(:ggplot)

function vdp_rhs(u, params)
    x, y = u
    μ, = params
    dx = y
    dy = μ*(1 - x^2)*y - x
    return [dx,dy]
end

function vdp_du(du,u,params,t)
    du .= vdp_rhs(u,params)
end

mp = @manipulate for μ in slider(1.0:0.5:3.0; label="μ")
    params = [μ]
    u0 = [4.0, 6.0]
    Tmax = 80.0
    tspan=(0.0,Tmax)

    vdp_prob = ODEProblem(vdp_du,u0,tspan,params)
    vdp_sol = DifferentialEquations.solve(vdp_prob)

    plt = plot(vdp_sol.t, map(x->x[1], vdp_sol.u), linewidth=2)
end

fdplotly(json(mp)) # hide
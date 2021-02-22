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
    Layout(;xaxis_title = "T", yaxis_title = "x²+y²", title="Evolution of the time average ϕᵤ(T) = (1/T)∫₀ᵀ ‖u(t)‖² dt;\nbound Φ̄ ≤ $(round(ϕ_mean[end],digits=3))"
    )
)

# display(plt_int) # hide - for VSCode or the REPL 
fdplotly(json(plt_int), style="width:680px;height:350px") # hide - for Franklin
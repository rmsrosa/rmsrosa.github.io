# This file was generated, do not modify it. # hide
using DynamicPolynomials
using SumOfSquares
using SDPAFamily

function get_bound_vdp(μ, ϕ, Vdeg)
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
optim = [get_bound_vdp(μ, ϕ, Vdeg) for Vdeg in Vdeg_range]

bounds = [optim[j][end] for j in 1:length(optim)]

plt_sos = PlotlyJS.plot(
    PlotlyJS.scatter(;x=Vdeg_range[2:end], y=bounds[2:end], yaxis_log=true, line_width=2, name="bound", mode="lines+markers", line_color="green"),
    Layout(;xaxis_title = "degree of auxiliary polynomial V", yaxis_title = "bound", title="Bounds on Φ̄ for different degrees for V"
    )
)
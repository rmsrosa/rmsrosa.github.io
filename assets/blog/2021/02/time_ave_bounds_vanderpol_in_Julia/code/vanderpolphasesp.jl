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
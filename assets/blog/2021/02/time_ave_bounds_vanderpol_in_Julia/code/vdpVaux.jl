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
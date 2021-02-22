# This file was generated, do not modify it. # hide
#hideall
using PrettyTables

io = IOBuffer()
pretty_table(io, hcat(Vdeg_range, map(o->o[end], optim)), ["degree" "bound"], backend=:html, formatters=ft_printf("%3.3f"))
println("~~~", String(take!(io)), "~~~")
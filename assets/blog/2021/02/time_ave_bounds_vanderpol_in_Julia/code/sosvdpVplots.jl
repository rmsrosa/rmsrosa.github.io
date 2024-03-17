# This file was generated, do not modify it. # hide
#hideall
for j=(1,2,4)
    # display(plt_composite[j]) # hide - for VSCode or the REPL 
    fdplotly(json(plt_composite[j]), style="width:680px;height:350px") # hide - for Franklin
end
# My personal website

This repository contains my personal website, rendered automatically by Github in [rmsrosa.github.io](https://rmsrosa.github.io).

It is built with [Franklin.jl](https://github.com/tlienart/Franklin.jl), in the [Julia language](https://julialang.org).

## Developing

For a live local preview of the page, serve it from the `website/` folder with

```julia
pkg> activate .

julia> using Franklin

julia> serve()
```

This generates the static website, under `__site`, and opens up the default browser with the locally generated site. Most changes made in the source files are automatically reflected in the generated site, but some (like those in files included in other files, such as `news.md` and `articles.md`) require you to stop the preview and serve it again.

## The css style 

The css (cascading style sheet) was based on the ["basic" Franklin template](https://tlienart.github.io/FranklinTemplates.jl/templates/basic/index.html), one of the many [Franklin templages available](https://tlienart.github.io/FranklinTemplates.jl/), but which I adapted to my taste.

The basic template was initiated with

```julia
using Franklin

newsite("website"; template="basic")
```

Then, I modified the original `css` files and added the desired contents.

## Blog comments

The blog comments are handled by [uterances](https://utteranc.es) and stored in the repo [github.com/rmsrosa/blog_comments](https://github.com/rmsrosa/blog_comments).

Franklin generates static sites, so it is not possible to have blog comments directly with it. However, there are several comment engines that can be included in a static site via javascript or iframe. Here is a list of some of them: [utterances](https://utteranc.es), [StaticMan](https://staticman.net), [IntenseDebate](https://intensedebate.com), [Isso](https://posativ.org/isso/), [Remark42](https://github.com/umputun/remark42), [Talkyard](https://www.talkyard.io), [GraphComment](https://graphcomment.com/en/), [Muut](https://muut.com), [Commento](https://commento.io), and [Disqus](https://disqus.com). Some are free, some are paid, and some paid ones have limited free plans. Some are open source and some are closed source. I opted for [utterances](https://utteranc.es), since it is free, open-source, pretty easy to install, and all the comments are directly accessible in another github repo (or the same as the website repo, if you like). The negative side is that only those with a github account can comment on it.

## Videos and animated gifs

I followed [StackExchange: How do I convert a video to GIF using ffmpeg, with reasonable quality?](https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality) to build some animated gifs.

For example, the periodic NSE simulation animation was reformatted with

```zsh
ffmpeg -ss 0 -t 9 -i movie01xx.mp4 -vf "fps=10,scale=448:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 nsepersim.gif
```

The salt-layer evolution movie was reformatted with

```zhs
ffmpeg -ss 0 -i potencial_ms_cropped.mp4 -vf "fps=15,scale=512:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 1 potencial_ms_cropped.gif
```

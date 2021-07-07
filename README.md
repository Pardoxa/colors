# Tired of searching for colors that look good in black and white?

Look no more!
Here I implement the colorscheme of https://arxiv.org/abs/1108.5083

## Usage: colors.rb
```bash
./colors.rb NUM_COLORS
```
Where NUM_COLORS is the number of colors you want to get.
Creates a colors.html file, which you can look at with your browser to see
the colors as well as their hex values and an estimated grayscale.
Note: In gnuplot you can use hex values with something like

```gnuplot
plot sin(x) lc rgbcolor "#A00000"
```

For more options use
```bash
./colors.rb NUM_COLORS --help
```

## colors.gp

An example for a heatmap. Intended for copying the palett (and functions for the palett) out of there
into where you need them

## Other helpful recources

https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3
https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html
https://www.nature.com/articles/nmeth.1618

# Plotting

Although data generated with `PKPDsim` can of course be plotted with any plotting library, some guidance is given below for plotting the data with `ggplot2` and with the `PKPDplot` library (based on `ggplot2`). The latter library is a complimentary library to `PKPDsim` and makes it easy and fast to create the most common plots for PKPD simulations.

## Using ggplot

The output dataset from `sim_ode()` can be fed into `ggplot2` without modification, use either:

    ggplot(dat, aes(x = t, y = y, group=id)) + geom_line()

or using the `dplyr` / `magittr` approach:

    dat %>% ggplot(aes(x = t, y = y, group=id)) + geom_line()

If you used the option `only_obs=FALSE` (which is default), then you will have observations from all compartments in your dataset. Hence, you will have to facet the plot to make separate plots per compartment:

    ggplot(dat, aes(x = t, y = y, group=id)) +
      geom_line() +
      facet_wrap(~comp)

## Using PKPDplot

While `ggplot2` is extremely versatile and can basically make any plot of your data that you dream of, most often you'll probably just want a simple plot of the PK profile for a single patient or an overview of the population, e.g. with a confidence interval. The add-on library `PKPDplot` (available from [GitHub](https://github.com/ronkeizer/PKPDplot)) takes away most of the burden of creating these standard plots. It will only show observations, and automatically switch between a plot for a single individual and a population. The plot can be customized using the `show` argument, as is shown in the examples below.

### Single individual

...

### Population, spaghetti plot

...

### Population, confidence interval

...

### Customization options

...

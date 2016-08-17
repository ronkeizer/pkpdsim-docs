# Simulation

The `sim_ode()` function will combine the model, the parameters, and the regimen, and simulate out the ODE system. It will return a `data.frame` in the long format, i.e. one observation per row, and split by compartment and individual. The command for `sim_ode` looks e.g. like this:

    dat <- sim_ode(
      ode = model,              # created using new_ode_model()
      parameters = parameters,  # just a list of parameters
      regimen = regimen         # created using new_regimen
    )

Output from this function looks e.g.:

    data

Below is a short description of the main arguments to `sim_ode`.

## Observations

By default, the observation times will include an observation every 1 hour. However, you can specify a vector of observation time:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      t_obs = c(0.5, 2, 4, 8, 12, 16, 24)
    )

Also, using the code above, `sim_ode()` will return a `data.frame` with the data for all compartments.
If you are only interested in the observed data (i.e. the concenttions in the case of PK), you can filter those out
by specifying the `only_obs = TRUE` option (or filter them out manually by comparment, of course). Please note that the
`comp` column in the dataset will have the indices for all the compartments, as well as an extra set of rows for the `"obs"`
 (observation) data, which is scaled by the scaling factor specified in the model.

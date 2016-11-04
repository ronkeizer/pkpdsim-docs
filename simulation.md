# Simulation

The `sim_ode()` function will combine the model, the parameters, and the regimen, and simulate out the ODE system. It will return a `data.frame` in the long format, i.e. one observation per row, and split by compartment and individual. The command for `sim_ode` looks e.g. like this:

    dat <- sim_ode(
      ode = model,              # created using new_ode_model()
      parameters = parameters,  # just a list of parameters
      regimen = regimen         # created using new_regimen
    )

By default, the observation times will include an observation every 1 hour. However, you can specify a vector of observation times to get only those observations:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      t_obs = c(0.5, 2, 4, 8, 12, 16, 24)
    )

## Output

Using the code above, `sim_ode()` will return a `data.frame` with the data for all compartments.
If you are only interested in the observed data (i.e. the concenttions in the case of PK), you can filter those out
by specifying the `only_obs = TRUE` option (or filter them out manually by comparment, of course). Please note that the
`comp` column in the dataset will have the indices for all the compartments, as well as an extra set of rows for the `"obs"`
 (observation) data, which is scaled by the scaling factor specified in the model.

 ## Parameters and covariates

 Especially if covariates and between-subject variability is included in the simulation, it is often useful to include these in the output table as well. Use the `output_include` argument for this:

    dat <- sim(pk1, parameters = p, regimen = reg,
      covariates_table = cov_table,
      covariates_implementation = list(SCR = "interpolate"),
      omega = c(0.1, 0.05, 0.1), n_ind = 50,
      output_include = list(parameters = TRUE, covariates=TRUE)
    )

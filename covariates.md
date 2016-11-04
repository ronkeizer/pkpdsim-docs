# Covariates

Covariates are implemented using the `new_covariate()` function, wrapped in a `named list`. E.g. the following is the most basic specification:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      covariates = list("WT" = new_covariate(value = 70), "SCR" = new_covariate(value = 120))
    )

The names in the covariate list-object should correspond **exactly** with the names of the covariates in the model.

## Time-varying covariates

Time-varing covariates, such as creatinine values can be implemented easily as well. They just require the additional `times` argument:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      covariates = list("WT" = new_covariate(value = 70),
                        "CR" = new_covariate(
                          value = c(0.8, 1, 1.2),
                          times = c(0, 48, 72))
      )
    )

By default, `PKPDsim` assumes that you want to interpolate between measurements of the time-varying covariates. If you prefer to implement the covariate using *last-observation-carried-forward* (in other words a step function), specify the `method = "LOCF"` argument to the `new_covariate()` function.

## Covariates for multiple patients

A table of covariates can be supplied to `sim_ode()` with covariate values per individual. It can handle both static and time-varying covariates. A covariate table could look like this:

    id  WT   SCR  t
    1   40   50   0
    1   45  150   5
    2   50   90   0
    3   60  110   0

The `id` and `t` (time) columns can be omitted when only static covariates are to be used. Make sure that the headers used for the covariates match *exactly* with the covariate names specified in the model definition.

With the above `data.frame` called `cov_table`, the call to `sim_ode()` would then become:

    sim_ode(ode = model, parameters = parameters, regimen = regimen,
            covariates_table = cov_table)

*Note: at current, PKPDsim does not handle missing covariate values. If you do have missing covariate data, probably the best approach would be to impute the values manually before simulation, e.g. based on the mean observed / known value, or the correlation between the covariates.*

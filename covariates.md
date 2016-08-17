# Covariates

Covariates are implemented using the `new_covariate()` function, wrapped in a `named list`. E.g. the following is the most basic specification:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      covariates = list("WT" = new_covariate(value = 70))
    )

Note that the name in the list should correspond **exactly** with the name of the covariate in the model.

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

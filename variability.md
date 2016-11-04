# Between subject-variability

This can be implemented using the `n` and `omega` options. The `omega` (the `omega` nomenclature is borrowed from NONMEM) should be specified as either a **vector** defining the lower triagle of the BSV or $$\Omega$$ matrix, or as a **matrix** defining the full $$\Omega$$ matrix. An alternative option is to specify the between-subject variability as CV, using the `cv_to_omega()` function.

The following:

    dat <- sim_ode(
      ode = model, parameters = parameters, regimen = regimen, n = 50,
      omega = c(0.2,
                0.05, 0.1)
    )

will simulate out data for 50 patients, assuming an Omega matrix as defined above. ALternatively, the $$\Omega$$ could also have been defined as:

    dat <- sim_ode(
      ode = model, parameters = parameters, regimen = regimen, n = 50,
      omega = matrix(c(0.2, 0.05,
                       0.05, 0.1), ncol=2)
    )

Or using the coefficient of variation and without correlation between parameters:

    dat <- sim_ode(
      ode = model, parameters = parameters, regimen = regimen, n = 50,
      omega = cv_to_omega(list(CL = 0.1, V = 0.1))
    )

Note that using the `cv_to_omega` function assumes the *CV is on the SD-scale* and not on the variance scale (and the definition of CV uses the assumption $$1 + \eta \approx 1 * \exp(\eta)$$).


## Variability type

By default, PKPDsim will assume exponential distribution of all parameters if `omega` is specified. If normal distribution is desired for all parameters, please use the `omega_type="normal"` argument:

    dat <- sim_ode(
      ode = model, parameters = parameters, regimen = regimen, n = 50,
      omega = c(0.2,
                0.05, 0.1),
      omega_type = "normal"
    )

*Note: at current, parameter distributions can only be all-exponential or all-normal. Future version of PKPDsim will allow specification per parameter.*

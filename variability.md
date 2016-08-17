# Between subject-variability

This can be implemented using the `n` and `omega` options. The `omega` should be specified as a vector defining the lower triagle of the BSV or Omega matrix (the `omega` nomenclature is borrowed from NONMEM). The following:

    dat <- sim_ode(
      ode = model,
      parameters = parameters,
      regimen = regimen,
      n = 50,
      omega = c(0.2 ,
                0.05, 0.1)
    )

will simulate out data for 50 patients, assuming an Omega matrix as defined above  (using only the lower triangle).

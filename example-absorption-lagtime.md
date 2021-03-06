# Absorption with lag time

Specify the `lagtime` when you create the model using `new_ode_model`. The lag time can either be a number, or a string referring to a parameter (e.g. "ALAG"). If a single number or parameter is specified, the lag time will apply to the default dose compartment only. Alternatively, it is also possible to specify a vector of lag times, with a value for each compartment.

    pk  <- new_ode_model(code = "
                         dAdt[1] = -KA * A[1]
                         dAdt[2] = KA*A[1] -(CL/V) * A[2]
                         ",
                         obs = list(cmt = 2, scale="V"),
                         dose = list(cmt = 1),
                         lagtime = "ALAG"
    )

    r <- new_regimen(amt = c(100, 100, 100), times = c(0, 12, 24), cmt = 1)
    p <- list(CL = 5, V  = 10, KA = 0.25, ALAG = 2)
    sim_ode (ode = "pk",
                    n_ind = 25,
                    omega = cv_to_omega(par_cv = list("CL"=0.1, "V"=0.1, "KA" = .1, "ALAG" = 0.3), p),
                    par = p,
                    regimen = r,
                    verbose = FALSE,
                    only_obs = TRUE) %>% plot()

# Speed

The simulation backend in `PKPDsim` uses an ODE solver written in C++ (`Boost::odeint`) to make sure simulations are fast. Therefore, for most simulation problems computational speed will not be an issue. Even simulating thousands (or millions) of patients for complex models will rarely take more than a few minutes. Simpler simulation problems will commonly take seconds to complete.

However, in some special cases speed could become an issue, and for that it is important to understand the structure of PKPDsim's main function (`sim_ode()`) because. The `sim_ode()` function is composed of three parts:

1. preprocessing (R)
2. looping over subjects, solving ODE for each subject (R/C++)
3. post-processing (R)

From this structure it is easy to understand that when you would request simulation of 1,000 patients:

    dat <- sim_ode(ode = mod, ...., n = 1000)

the pre- and post-processing parts will take relatively minor computational time, since the main part will be the loop simulating the PK for the subjects. However, if instead you would write a loop yourself to simulate 1,000 patients, and would call sim_ode() repeatedly:

    dat <- c()
    for(i in 1:1000) {
        dat <- rbindlist(dat, sim_ode(ode = mod, ...., n = 1))
    }

now in each iteration also the pre- and post-processing functionality would be invoked, and the overall simulation will take much longer than before, probably by an order of magnitude. The same concept applies if you would use `sim_ode()` in the context of population (NLME) or individual (MAP) estimation, or in optimal design in evaluation of the FIM.

There is a different way to solve ODEs with `PKPDsim` though, which uses only the core ODE solver function and does not perform pre-/post-processing. If you need to use PKPDsim in an iterative context as described above, you should therefore use the `sim_core()` function instead, and perform the pre- and post-processing outside of the main loop, e.g.:

    design <- sim_ode(mod = mod, ...., return_design=TRUE)
    dat <- c()
    for(i in 1:1000) {
        dat <- rbindlist(dat, sim_core(design = design, ode = mod))
    }
    # potentially any post-processing here

## Comparison with other packages

The R package `RxODE` implements a similar approach (i.e. overhead from pre- / post-processing separated from main simulation function) by default, while `mrgsolve` is more similar to `PKPDsim` with much overhead inside the main simulation function. Therefore, especially when used in an iterative context, `RxODE` will be much faster than `PKDPsim` and `mrgsolve` by default, while `PKPDsim` and `mrgsolve` are broadly similar in terms of speed. However, when using the `sim_core()` function as outlined above, our benchmarks indicate that simulation speed for `PKDDsim` is highly similar to that obtained with the `RxODE` package.

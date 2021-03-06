# Model

`new_ode_model` is the function that creates a new ODE model that can be used in the `sim_ode()` command. It defines the ODE system and sets some attributes for the model. The model can be specified in three different ways:

- `model`: a string that references a model from the library included in `PKPDsim`. Examples in the current library are e.g. `pk_1cmt_oral`, `pk_2cmt_iv`. To show the available models, run `new_ode_model()` without any arguments.
- `code`: using code specyfing derivatives for ODE specified in *pseudo-R* code
- `file`: similar to `code`, but reads the code from a file

## Model from library

For example, a 1-compartment oral PK model can be obtained using:

    pk1 <- new_ode_model(model = "pk_1cmt_oral")

Run the `new_ode_model()` function without arguments to see the currently available models:

    > new_ode_model()
      Either a model name (from the PKPDsim library), ODE code, an R function, or
      a file containing code for the ODE system have to be supplied to this function.
      The following models are available:
      pk_1cmt_iv
      pk_1cmt_iv_auc
      pk_1cmt_iv_mm
      pk_2cmt_iv
      pk_2cmt_iv_auc
      pk_1cmt_oral

## Custom model from code

The custom model needs to be specified as a string or text block:

    pk1 <- new_ode_model(code = "
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CL/V) * A[2]
    ")

The input code should adhere to the follow rules:

- the derivaties in the ODE system are defined using `dAdt`
- array indices for the derivatives and compartments are indicated with `[ ]` and start at 1.
- equations are defined using `=`
- some expections apply, e.g. power functions (see below).

The input code is translated into a C++ function. You can check that the model compiled correctly by typing the model name on the R command line, which prints the model information:

    > pk1
    ODE definition:

      double   KEL = CL/V;
      dAdt[0] = -KA * A[0] + rate;
      dAdt[1] = +KA * A[1] -KEL * A[1];
      ;

    Required parameters: CL, V, KA
    Number of compartments: 2
    Observation compartment: 1
    Dependent variable scaling: 1

If you want even more detailed information, you can also print the actual C++ function that is used *under-the-hood* by specifying the `cpp_show_code=TRUE` argument to the `new_ode_model()` function.

## More custom model options

You can introduce new variables in your code, but you will have to define them using `declare_variables` argument too:

    pk1 <- new_ode_model(code = "
      KEL = CL/V
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -KEL * A[2]
    ", declare_variables = c("KEL"))

Also, when you want to use covariates in your ODE system (more info on how to define covariates is in the *Covariates* section), you will have to define them, both in the code and in the function call:

    pk1 <- new_ode_model(code = "
      CLi = WT/70
      KEL = CLi/V
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CL*(WT/70)/V) * A[2]
    ", declare_variables = c("KEL", "CLi"), covariates = c("WT"))

One exception to the input code syntax is the definition of power functions. `PKPDsim` does not translate those from the *pseudo-R* code to valid C++ syntax automatically. C/C++ does not use the `^` to indicate power functions but uses the `pow(value, base)` function instead, so e.g. an allometric model should be written as:

    pk1 <- new_ode_model(code = "
      CLi = CL * pow((WT/70), 0.75)
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CLi/V) * A[2]
    ", declare_variables = c("CLi"))

### Dosing / bioavailability

The default dosing compartment and bioavailability can be specified using the `dose` argument. By default, the dose will go into compartment `1`, with a bioavailability of `1`. The `bioav` element in the list can be either a number or a character string referring a parameter.

    pk1 <- new_ode_model(code = "
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CL/V) * A[2]
    ",
      dose = list(cmt = 1, bioav = "F1"))

For dosing based on mg/kg, at currently there is no solution for that using `new_regimen()`, although that might change in the future. The way to implement this at the moment is by scaling the dose by the "weight" covariate using the bioavailability:

    mod <- new_ode_model(code = "
      dAdt[1] = -(CL/V)*A[1];
    ",
      dose = list(cmt = 1, bioav = "WT"),
      obs = list(cmt = 1, scale = "V"), covariates = covs)

### Observations

The observation compartment can be set by specifying a list to the `obs` argument, with the elements `obs` and `scale`.

    pk1 <- new_ode_model(code = "
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CL/V) * A[2]
    ", obs = list(cmt = 2, scale = "V"))

The `scale` can be either a parameter or a number, the `cmt` can only be a number.

*Note that the variables specified inside the differential equation block are not available as scaling parameters. E.g. for allometry you will have to redefine the scaled volume as follows:*

    pk1 <- new_ode_model(code = "
      Vi = V * (WT/70)
      dAdt[1] = -KA * A[1]
      dAdt[2] = +KA * A[1] -(CL/Vi) * A[2]
    ", obs = list(cmt = 2, scale = "V * (WT/70)"))

## Custom model from file

The same syntax as explained above applies, but using the `file=` argument the input code is read from the specified file. This is just a convenience function, i.e. it allows you to modularize your code, and separate models and R code.

    pk1 <- new_ode_model(
      file = "pk_1cmt_oral_nonlin_v1.txt",
      declare_variables = c("KEL", "CLi")
    )

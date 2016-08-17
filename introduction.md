# Introduction

**Please note: documentation in development.**

 `PKPDsim` is a library for numerical integration of ODE systems, in particular pharmacokinetic-pharmacodynamic (PK-PD) mixed-effects models.

In pharmacometrics, models are often defined as systems of ordinary differential equations (ODEs). Although solving ODEs numerically in R is relatively straightforward using e.g. the `deSolve` library, the implementation of e.g. infusions and complex dosing regimens as well as the incorporation of random effects is cumbersome. Outside of R, a tool like Berkeley Madonna provides excellent interactivity features and is fast, but is much inferior to R regarding plotting functionality, cumbersome regarding implementation of dose regimens and multi-level variability, and also not open source.

In short, the issues above were the impetus for developing the `PKPDsim` library in R. For fast numerical integration of the ODEs, the module uses the Boost C++ library under the hood.

If this library is useful to you in your company or academic work, please let me know at @ronpirana. For any suggestions on new features or to report any bugs, please don't send me emails but [open an issue](https://github.com/ronkeizer/PKPDsim/issues) on GitHub.

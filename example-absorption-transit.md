# Absorption transit compartments

The code below implements the transit compartment model for absorption compartments as described by Savic et al. JPKPD 2007. Please note that this implementation assumes that all drug amount has been absorbed within the dosing interval. Such an assumption might not always hold. Also, for this implementation of dosing, it is essentioal to set the bioavailability for the dose compartment to 0, since dosing is now implemented using a separate analytical equation.

*Note: a simplified way of coding the transit compartments model will be added soon to PKPDsim.*

    library(PKPDsim)
    library(PKPDplot)

    parameters <- list(CL = 15, V = 50, MTT = 2.5, N = 4, KA = 1)
    reg1 <- new_regimen(amt = 100, n = 3, interval = 12) # needs dummy doses

    mod <- new_ode_model(code = "
      tad = t - t_prv_dose
      KTR = (N+1)/MTT
      LNFAC= log(2.506628)+(N+0.5)*log(N)-N
      dAdt[1] = exp(log(prv_dose) + log(KTR) + N*log(KTR * tad) - KTR * tad - LNFAC) - KA*A[1]
      dAdt[2] = KA*A[1]-CL/V*A[2]
    ", declare_variables = c("LNFAC", "KTR", "tad"),
                         parameters = parameters,
                         dose = list(cmt = 1, bioav = 0), obs = list(cmt = 2, scale = "V"))

    sim_ode(ode = mod, regimen = reg1, parameters = parameters, n = 50,
            omega = cv_to_omega(list(CL = 0.1, V = 0.1, MTT = 0.2, N =0.1, KA=0.1), parameters),
            t_obs = seq(0, 36, .5)) %>% plot()

![Transit_cmt](/assets/images/transit_cmts.png "Transit compartments absorption")

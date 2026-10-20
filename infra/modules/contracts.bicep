@allowed([true])
param validSecurity bool
@allowed([true])
param validSettings bool
@allowed([true])
param validActivation bool
@allowed([true])
param validNetwork bool
output valid bool = validNetwork && validSecurity && validSettings && validActivation

/* Top-level state */
state(dormant).
state(init).
state(idle).
state(monitoring).
state(error_diagnosis).
state(safe_shutdown).
initial_state(dormant,null).

/* States in init state */
state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).
initial_state(boot_hw,init).

/* States in monitoring state */
state(monidle).
state(regulate_environment).
state(lockdown).
initial_state(monidle,monitoring).

/* States in error_diagnosis state */
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
initial_state(error_rcv,error_diagnosis).

/* States in lockdown state */
state(prep_vpurge).
state(risk_assess).
state(alt_temp).
state(alt_psi).
state(safe_status).
initial_state(prep_vpurge,lockdown).
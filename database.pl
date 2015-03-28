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
superstate(init,boot_hw).
superstate(init,senchk).
superstate(init,tchk).
superstate(init,psichk).
superstate(init,ready).
initial_state(boot_hw,init).

/* States in monitoring state */
state(monidle).
state(regulate_environment).
state(lockdown).
superstate(monitoring,monidle).
superstate(monitoring,regulate_environment).
superstate(monitoring,lockdown).
initial_state(monidle,monitoring).

/* States in error_diagnosis state */
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
superstate(error_diagnosis,error_rcv).
superstate(error_diagnosis,applicable_rescue).
superstate(error_diagnosis,reset_module_data).
initial_state(error_rcv,error_diagnosis).

/* States in lockdown state */
state(prep_vpurge).
state(risk_assess).
state(alt_temp).
state(alt_psi).
state(safe_status).
superstate(lockdown,prep_vpurge).
superstate(lockdown,risk_assess).
superstate(lockdown,alt_temp).
superstate(lockdown,alt_psi).
superstate(lockdown,safe_status).
initial_state(prep_vpurge,lockdown).

/* Top-level transitions */
transition(dormant,init,start,null,null).
transition(init,idle,init_ok,null,null).
transition(init,error_diagnosis,init_crash,null,init_error_msg).
transition(idle,monitoring,begin_monitoring,null,null).
transition(idle,error_diagnosis,idle_crash,null,idle_error_msg).
transition(monitoring,error_diagnosis,monitor_crash,'inlockdown = false',moni_err_msg).
transition(error_diagnosis,dormant,retry_init,'retry < 3','retry++').
transition(error_diagnosis,safe_shutdown,shutdown,'retry > 2',null).
transition(error_diagnosis,idle,idle_rescue,null,null).
transition(error_diagnosis,monitoring,moni_rescue,null,null).
transition(safe_shutdown,dormant,sleep,null,null).

/* Transitions in the init state */
transition(boot_hw,senchk,hw_ok,null,null).
transition(senchk,tchk,senok,null,null).
transition(tchk,psichk,t_ok,null,null).
transition(psichk,ready,psi_ok,null,null).

/* Transitions in the monitoring state */
transition(monidle,regulate_environment,no_contagion,null,null).
transition(monidle,lockdown,contagion_alert,null,'FACILITY_CRIT_MSG;inlockdown := true').
transition(lockdown,monidle,purge_succ,null,'inlockdown := false').
transition(regulate_environment,monidle,after_100ms,null,null).

/* Transitions in the lockdown state */
transition(prep_vpurge,'alt_temp;alt_psi',initiate_purge,null,lock_doors).
transition('alt_temp;alt_psi',risk_assess,tcyc_comp;psicyc_comp,null,null).
transition(risk_assess,prep_vpurge,null,'risk > 0.01',null).
transition(risk_assess,safe_status,null,'risk <= 0.01',unlock_doors).

/* Transitions in the error_diagnosis state */
transition(error_rcv,applicable_rescue,null,'err_protocol_def = true',null).
transition(error_rcv,reset_module_data,null,'err_protocol_def = false',null).
transition(applicable_rescue,exit,apply_protocol_rescues,null,null).
transition(reset_module_data,exit,reset_to_stable,null,null).

/* Exit transitions */
transition(dorman,exit,kill,'inlockdown = false',null).
transition(init,exit,kill,'inlockdown = false',null).
transition(idle,exit,kill,'inlockdown = false',null).
transition(monitoring,exit,kill,'inlockdown = false',null).
transition(error_diagnosis,exit,kill,'inlockdown = false',null).
transition(safe_shutdown,exit,kill,'inlockdown = false',null).
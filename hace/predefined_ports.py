start_inputs = [
	"start", 
	"ap_start",
];

end_outputs = [
	"ap_done", 
	"finish", 
];



clocks = [
	"clock",
	"clk", 
	"clk2x", 
	"clk1x_follower",
	"ap_clk",
	"clken",
];
resets = [
    "reset",
	"rst",
	"ap_rst", 
	"ap_reset",
	"aclr"
];

control_inputs = [
	*start_inputs,
	*clocks,
	*resets,
];

control_outputs = [
	"ap_idle", 
	"ap_ready", 
	"ap_start",
	*end_outputs,
];



stall_conditions = [
	"fsm_stall",
	"memory_controller_waitrequest"
];



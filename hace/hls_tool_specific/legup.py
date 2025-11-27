import hace.memory_port as MEMORY
import re;

memory_port_re = r"(.*)_(enable|in|out|address|write_enable|byteena)_(a|b)";
memory_port_map = {
	"_enable" : MEMORY.ENABLE,
	"_write_enable" : MEMORY.WRITE_ENABLE,
	"_in" : MEMORY.WRITE_DATA,
	"_out": MEMORY.READ_DATA,
	"_address" : MEMORY.ADDRESS,
	"_byteena" : "_byteena",
};
port_names = ["_a", "_b"];


def parse(s : str):
	port_list = [port_name for port_name in port_names if s.endswith(port_name)];
	if not port_list:
		return None;

	port : str = port_list[0];
	without_port = s.removesuffix(port);
	signal_list = sorted([signal for signal in memory_port_map if without_port.endswith(signal)], key = lambda a: -len(a));
	if not signal_list:
		return None;

	signal = signal_list[0];
	memory_name = without_port.removesuffix(signal);
	return (memory_name, port), memory_port_map[signal];

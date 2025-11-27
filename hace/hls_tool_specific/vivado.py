import hace.memory_port as MEMORY
import re;

memory_port_re = r"(.*?)_(ce|we|address|d|q)(\d*)";
memory_port_map = {
	"ce": MEMORY.ENABLE,
	"we": MEMORY.WRITE_ENABLE,
	"d" : MEMORY.WRITE_DATA,
	"q" : MEMORY.READ_DATA,
	"address": MEMORY.ADDRESS,
};

def parse(s: str):
	matches = re.search(memory_port_re, s);
	if not matches:
		return None;
	else:
		return (matches.group(1), matches.group(3)), memory_port_map.get(matches.group(2), matches.group(2));

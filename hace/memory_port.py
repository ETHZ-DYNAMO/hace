# TODO, there is an index mapping for memory nodes here, reiify that!
ENABLE = "enable";
WRITE_ENABLE = "write_enable";
ADDRESS = "address";
WRITE_DATA  = "in";
READ_DATA  = "out";

full_memory_sub  = {"enable", "in", "out", "address", "write_enable"};
read_memory_sub  = {"enable",       "out", "address"                };
write_memory_sub = {"enable", "in"       , "address", "write_enable"};


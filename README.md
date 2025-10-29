# TF2/SDK-2013 Vscript Gutter
Tool that allows servers to override packed vscript files with the server's ones

# USAGE

This plugin replaces all instances of the "vscripts" keyvalue in a map with a file of the same name from the `scripts/vscripts/sm_vs_overrides/` directory, allowing you to override the files being executed.

E.G: A `logic_script` entity with `mymapvscript/load.nut` in it's `vscripts` kv will have the value replaced with `sm_vs_overrides/mymapvscript/load.nut`, if the file exists.
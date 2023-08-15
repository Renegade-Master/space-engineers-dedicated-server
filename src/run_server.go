package main

import (
	"fmt"
	"os"
)

// main executes the process of starting the Dedicated Server
func main() {
	steamCmd := "/usr/bin/steamcmd"
	var args []string
	attr := new(os.ProcAttr)

	attr.Files = []*os.File{os.Stdin, os.Stdout, os.Stderr}

	if process, err := os.StartProcess(steamCmd, args, attr); err != nil {
		fmt.Printf("ERROR Unable to run %s: %s\n", steamCmd, err.Error())
	} else {
		fmt.Printf("%s running as pid %d\n", steamCmd, process.Pid)
	}
}

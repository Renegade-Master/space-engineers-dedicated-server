package main

import (
	"fmt"
	"os"
)

// main executes the process of starting the Dedicated Server
func main() {
	steamCmd := "/usr/local/games/steamcmd.sh"
	args := []string{"--help"}
	attr := new(os.ProcAttr)

	attr.Files = []*os.File{os.Stdin, os.Stdout, os.Stderr}

	if process, err := os.StartProcess(steamCmd, args, attr); err != nil {
		fmt.Printf("ERROR Unable to run %s: %s\n", steamCmd, err.Error())
	} else {
		fmt.Printf("%s running as pid %d\n", steamCmd, process.Pid)

		if err := process.Kill(); err != nil {
			fmt.Printf("ERROR Unable to terminate process %s: %s\n", steamCmd, err.Error())
		} else {
			fmt.Printf("%s process terminated successfully\n", steamCmd)
		}
	}
}

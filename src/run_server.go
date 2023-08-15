package main

import (
	logger "log"
	"os"
	"strings"
)

var log = logger.Default()

func applyPreinstallConfig() {
	filepath := "/app/install_server.scmd"

	if steamFile, err := os.ReadFile(filepath); err != nil {
		log.Fatalf("ERROR Unable to open file [%s]: %s\n", filepath, err.Error())
	} else {
		oldFileContent := string(steamFile)
		oldText := "-beta GAME_VERSION"
		newText := "public"

		newFileContent := strings.Replace(oldFileContent, oldText, newText, 1)
		newFileContentByte := []byte(newFileContent)

		if err := os.WriteFile(filepath, newFileContentByte, 0444); err != nil {
			log.Fatalf("ERROR Unable to write file [%s]: %s\n", filepath, err.Error())
		}
	}
}

func runSteamCmd() {
	steamCmd := "/usr/local/games/steamcmd.sh"
	args := []string{"--help"}
	attr := new(os.ProcAttr)

	attr.Files = []*os.File{os.Stdin, os.Stdout, os.Stderr}

	if process, err := os.StartProcess(steamCmd, args, attr); err != nil {
		log.Fatalf("ERROR Unable to run %s: %s\n", steamCmd, err.Error())
	} else {
		log.Printf("%s running as pid %d\n", steamCmd, process.Pid)

		if err := process.Kill(); err != nil {
			log.Fatalf("ERROR Unable to terminate process %s: %s\n", steamCmd, err.Error())
		} else {
			log.Printf("%s process terminated successfully\n", steamCmd)
		}
	}
}

// main executes the process of starting the Dedicated Server
func main() {
	applyPreinstallConfig()
	runSteamCmd()
}

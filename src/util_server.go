package main

import (
	logger "log"
	"os"
	"os/exec"
	"strings"
)

var log = logger.Default()

const (
	serverExe     = "/home/steam/se_install/DedicatedServer64/SpaceEngineersDedicated.exe"
	serverExePath = "Z:\\home\\steam\\se_install\\DedicatedServer64"
	steamcmd      = "/usr/local/games/steamcmd.sh"
	steamcmdFile  = "/app/install_server.scmd"
)

func replaceTextInFile(filepath string, oldText string, newText string) {
	if file, err := os.ReadFile(filepath); err != nil {
		log.Fatalf("ERROR Unable to open file [%s]: [%s]\n", filepath, err.Error())
	} else {
		oldFileContent := string(file)

		newFileContent := strings.Replace(oldFileContent, oldText, newText, 1)
		newFileContentByte := []byte(newFileContent)

		if err := os.WriteFile(filepath, newFileContentByte, 0444); err != nil {
			log.Fatalf("ERROR Unable to write file [%s]: [%s]\n", filepath, err.Error())
		}
	}
}

func startExecutable(cmd *exec.Cmd) error {
	if err := cmd.Run(); err != nil {
		log.Fatalf("ERROR Unable to run [%s]: [%s]\n", cmd.Path, err.Error())
		return err
	} else {
		log.Printf("[%s] running as pid [%d]\n", cmd.Path, cmd.Process.Pid)
	}

	return nil
}

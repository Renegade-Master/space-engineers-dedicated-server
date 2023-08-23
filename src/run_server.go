package main

import (
	"fmt"
	logger "log"
	"os"
	"os/exec"
	"strings"
)

var log = logger.Default()

const (
	serverExe     = "/home/steam/se_install/DedicatedServer64/SpaceEngineersDedicated.exe"
	serverExePath = "S:\\home\\steam\\se_install\\DedicatedServer64"
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

func startServer() {
	_ = os.Setenv("WINEDEBUG", "-all")

	wineExecPath := fmt.Sprintf("-path %s", serverExePath)

	serverCmd := exec.Command("wine", serverExe, wineExecPath)
	serverCmd.Stdout = log.Writer()

	_ = startExecutable(serverCmd)
}

func runSteamCmd() {
	targetScript := fmt.Sprintf("+runscript %s", steamcmdFile)

	steamCmd := exec.Command(steamcmd, targetScript)
	steamCmd.Stdout = log.Writer()

	_ = startExecutable(steamCmd)
}

func applyPreinstallConfig() {
	filepath := steamcmdFile

	replaceTextInFile(filepath, "-beta GAME_VERSION", "-beta public")
}

// main executes the process of starting the Dedicated Server
func main() {
	log.Printf("Starting [Renegade-Master] Space Engineers Dedicated Server!")

	log.Printf("Applying Pre-Install Configuration")
	applyPreinstallConfig()

	log.Printf("Running SteamCMD to install the Space Engineers Dedicated Server")
	runSteamCmd()

	log.Printf("Running installed Space Engineers Dedicated Server!")
	startServer()

	log.Printf("Stopping Space Engineers Dedicated Server")
}

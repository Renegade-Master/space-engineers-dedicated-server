package main

import (
	"fmt"
	"os"
	"os/exec"
)

func startServer() {
	_ = os.Setenv("DISPLAY", ":5.0")
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

	// Create headless window
	screenFlag := fmt.Sprintf("-screen %s", screenSelection)
	resolution := "1024x768x16"

	displayCmd := exec.Command("Xvfb", displaySelection, screenFlag, resolution)
	displayCmd.Stdout = log.Writer()

	go func() { _ = startExecutable(displayCmd) }()
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

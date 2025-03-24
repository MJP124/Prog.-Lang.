package main

import (
	"time"

	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func updateClocks(localLabel, utcLabel, newYorkLabel, tokyoLabel *widget.Label) {
	for {
		localLabel.SetText("Local Time: " + time.Now().Format("15:04:05"))
		utcLabel.SetText("UTC Time: " + time.Now().UTC().Format("15:04:05"))

		nyLocation, _ := time.LoadLocation("America/New_York")
		tokyoLocation, _ := time.LoadLocation("Asia/Tokyo")

		newYorkLabel.SetText("New York Time: " + time.Now().In(nyLocation).Format("15:04:05"))
		tokyoLabel.SetText("Tokyo Time: " + time.Now().In(tokyoLocation).Format("15:04:05"))

		time.Sleep(1 * time.Second)
	}
}

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("World Clock")

	localLabel := widget.NewLabel("")
	utcLabel := widget.NewLabel("")
	newYorkLabel := widget.NewLabel("")
	tokyoLabel := widget.NewLabel("")

	go updateClocks(localLabel, utcLabel, newYorkLabel, tokyoLabel)

	myWindow.SetContent(container.NewVBox(
		localLabel,
		utcLabel,
		newYorkLabel,
		tokyoLabel,
	))

	myWindow.ShowAndRun()
}

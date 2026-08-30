package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8002" // Puerto por defecto solicitado
	}
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "logistics service ok")
	})

	// Aquí irían rutas para cotizar rutas, coordinar entregas, etc.
	log.Printf("Logistics service listening on :%s\n", port)
	if err := http.ListenAndServe("0.0.0.0:"+port, nil); err != nil {
		log.Fatalf("failed to start server: %v", err)
	}
}

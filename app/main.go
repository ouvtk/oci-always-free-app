package main

import (
    "net/http"
    "log"
)

func healthEndpoint(w http.ResponseWriter, req *http.Request) {
	okCode := 200
    w.Header().Set("Content-Type", "text/plain")
	w.WriteHeader(okCode)
    w.Write([]byte(http.StatusText(okCode)))
}

func main() {
	http.HandleFunc("/health", healthEndpoint)
	err := http.ListenAndServe(":80", nil)
	if err != nil {
		log.Fatal(err)
	}
}
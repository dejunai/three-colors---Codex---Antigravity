import http.server
import os
import sys

PORT = 8040
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DIRECTORY = os.path.join(BASE_DIR, "builds", "web")

class GodotWebHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        # Cross-Origin Isolation headers for Godot 4 Web (SharedArrayBuffer & AudioWorklet support)
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Access-Control-Allow-Origin", "*")
        super().end_headers()

    def guess_type(self, path):
        if path.endswith(".wasm"):
            return "application/wasm"
        if path.endswith(".pck"):
            return "application/octet-stream"
        return super().guess_type(path)

def run():
    server_address = ("127.0.0.1", PORT)
    with http.server.ThreadingHTTPServer(server_address, GodotWebHandler) as httpd:
        print("==================================================", flush=True)
        print(f" Godot 4 HTML5 Server running at: http://localhost:{PORT}", flush=True)
        print(f" Serving files from: {DIRECTORY}", flush=True)
        print(" Press Ctrl+C to stop the server.", flush=True)
        print("==================================================", flush=True)
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer terminated.", flush=True)

if __name__ == "__main__":
    run()

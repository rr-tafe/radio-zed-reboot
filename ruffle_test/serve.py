import functools, http.server, os, sys

root = os.path.dirname(os.path.abspath(__file__))
os.chdir(root)
handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=root)
http.server.ThreadingHTTPServer(("127.0.0.1", int(sys.argv[1]) if len(sys.argv) > 1 else 8765), handler).serve_forever()

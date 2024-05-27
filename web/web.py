import os
from datetime import datetime
from flask import Flask, request
from pg8000.native import Connection

app = Flask(__name__)
server_start = datetime.now()


@app.route("/health")
def health():
    return "OK"


@app.route("/")
def index():
    if request.headers.getlist("X-Forwarded-For"):
        client_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        client_ip = request.remote_addr

    server_name = os.environ.get("SERVER_NAME", "Unknown")
    server_now = datetime.now()

    conn = None
    try:
        conn = Connection(
          host=os.environ.get("POSTGRES_HOST") or "localhost",
          port=int(os.environ.get("POSTGRES_PORT") or 5432),
          user=os.environ.get("POSTGRES_USER") or "postgres",
          password=os.environ.get("POSTGRES_PASSWORD") or "postgres",
          database=os.environ.get("POSTGRES_DB") or "postgres",
          timeout=3.0,
        )
        db_now = conn.run("SELECT now()")[0][0]
    except Exception as e:
        db_now = f"<span style=\"color: red;\">DB Error: {e}</span>"
    finally:
        if conn:
            conn.close()

    return f"""
<!DOCTYPE html>
<html>
<head>
    <title>aws-fis-newbie</title>
    <meta charset="utf-8">
</head>
<body>
    <h2>It works!</h2>
    <table>
        <tr><td>Client IP</td><td>{client_ip}</td></tr>
        <tr><td>Server Name</td><td>{server_name}</td></tr>
        <tr><td>Server Start</td><td>{server_start}</td></tr>
        <tr><td>Server Now</td><td>{server_now}</td></tr>
        <tr><td>DB Now</td><td>{db_now}</td></tr>
    </table>
</body>
</html>
"""

app.run(host="0.0.0.0", port=5000, debug=True)

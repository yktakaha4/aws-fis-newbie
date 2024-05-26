import os
from datetime import datetime
from flask import Flask, request
from pg8000.native import Connection

app = Flask(__name__)

@app.route("/")
def hello_world():
    if request.headers.getlist("X-Forwarded-For"):
        client_ip = request.headers.getlist("X-Forwarded-For")[0]
    else:
        client_ip = request.remote_addr

    server_name = os.environ.get("SERVER_NAME", "Unknown")
    server_date = datetime.now()

    conn = None
    try:
        conn = Connection(
          host=os.environ.get("POSTGRES_HOST") or "localhost",
          port=int(os.environ.get("POSTGRES_PORT") or 5432),
          user=os.environ.get("POSTGRES_USER") or "postgres",
          password=os.environ.get("POSTGRES_PASSWORD") or "postgres",
          database=os.environ.get("POSTGRES_DB") or "postgres",
          timeout=10.0,
        )
        db_date = conn.run("SELECT now()")[0][0]
    except Exception as e:
        db_date = f"<span style=\"color: red;\">{e}</span>"
    finally:
        if conn:
            conn.close()

    return f"""
<h2>It works!</h2>
<table>
<tr><td>Client IP</td><td>{client_ip}</td></tr>
<tr><td>Server Name</td><td>{server_name}</td></tr>
<tr><td>Server Date</td><td>{server_date}</td></tr>
<tr><td>DB Date</td><td>{db_date}</td></tr>
</table>
"""

app.run(host="0.0.0.0", port=5000, debug=True)

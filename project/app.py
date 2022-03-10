import sqlite3
from flask import Flask, g

#configuration
DATABASE = "flaskk.db"

#create and initialize a new Flask app
app = Flask(__name__)

#load the config
app.config.from_object(__name__)

@app.route("/")

# connect to database
def connect_db():
    """Connects to the database."""
    rv = sqlite3.connect(app.config["DATABASE"])
    rv.row_factory = sqlite3.Row
    return rv

# create the database
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource("schema.sql", mode="r") as f:
            db.cursor().executescript(f.read())
        db.commit()


def hello():
    return "Hello, World!"


if __name__ == "__main__":
    app.run()
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    head = "<html><head><title>Docker App</title></head>"
    body = "<body>" \
           "<p align=center>Hello, World! It's <b>kevin shindel</b></p>" \
           "<hr/> <p>lorem ipsum dormir </p>" \
           "</body>"
    footer = "</html>"
    return head + body + footer

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
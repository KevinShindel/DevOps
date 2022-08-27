from flask import Flask, Response, request
import requests, hashlib, redis
import html

app = Flask(__name__)

cache = redis.StrictRedis(host='redis', port=6379, db=0)

default_name = "John Doe"
salt = "UNIQUE_SALT"

@app.route("/", methods=['GET', 'POST'])
def main_page():
    name = default_name
    if request.method == 'POST':
        name = html.escape(request.form['name'], quote=True)

    salted_name = salt + name
    name_hash = hashlib.sha256(salted_name.encode()).hexdigest()
    head = "<html><head><title>Docker App</title></head>"
    body = '''<body>
    <form method="post">
    Hello <input type="text" name="name" value="{0}">
    <input type="submit" value="Submit"/>
    </form>
    <p>You look like a:
    <img src="/monster/{1}"/>
           </body>'''.format(name, name_hash)
    footer = "</html>"
    return head + body + footer

@app.route('/monster/<hashed_name>')
def get_identicon(hashed_name):
    image = cache.get(hashed_name)

    if image is None:
        print ("[-] cache miss", flush=True)
        r = requests.get('http://dnmonster:8080/monster/' + hashed_name + '?size=80')
        image = r.content
        cache.set(hashed_name, image)
    else:
        print(f'[+] cache {hashed_name} <-- found in cache!', flush=True)

    return Response(image, mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
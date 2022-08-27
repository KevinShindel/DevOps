from unittest import TestCase, main
from app import app

class TestFlaskServer(TestCase):

    def setUp(self) -> None:
        app.config["TESTING"] = True
        self.app = app.test_client()

    def test_get_mainpage(self):
        name = "Kevin Shindel"
        page = self.app.post("/", data=dict(name=name))
        self.assertEqual(page.status_code, 200)
        self.assertIn(b"Hello", page.data)
        self.assertIn(bytes(name, 'utf8'), page.data)


    def test_xss_injection(self):
        data = '<script>Alarm!</script>'
        page = self.app.post("/", data=dict(name=data))
        self.assertNotIn(b"<script>", page.data)

if __name__ == '__main__':
    main()

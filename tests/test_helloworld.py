import manu_sdk


def test_helloworld():
    assert manu_sdk.example.hello_world() == "Hello World!"

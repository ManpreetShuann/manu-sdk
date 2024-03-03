import manu_sdk


def test_helloworld():
    assert manu_sdk.hello.hello_world() == 'Hello World!'

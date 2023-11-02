from IPython.core import getipython

def left(event):
    b = event.current_buffer
    b.cursor_left(count=event.arg)

ip = getipython.get_ipython()

ip.pt_app.key_bindings.add_binding(u'ñ')(left)  # type: ignore

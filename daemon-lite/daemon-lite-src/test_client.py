
import os
import json
import socket
import struct

SOCKET_PATH = "/tmp/daemon-lite"

with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
    sock.connect(SOCKET_PATH)

    send_payload = {
        "request": {
            "connect": 245346449271196
        }
    }
    # Serialise the payload into a JSON string
    send_payload_json = json.dumps(send_payload)
    # Determine the size of the JSON payload
    send_payload_size = len(send_payload_json)
    # Convert the size of the JSON payload into an array of 8 bytes
    # (which represents a 64-bits value)
    send_payload_size_bytes = send_payload_size.to_bytes(8, byteorder='little')

    # -- Sending the request --

    print("Sending ", send_payload_json)
    # First, send the size of the JSON payload to the socket
    sock.sendall(send_payload_size_bytes)
    # Then, send the JSON payload to the socket
    sock.sendall(send_payload_json.encode())

    # -- Reading the response --

    # Read 8 bytes (64-bits integer) for the payload size from the socket
    # This tells us how much to read from the socket for the response payload
    recv_payload_size_bytes = sock.recv(8)
    # Convert the array of bytes into an integer. This becomes the size of the response payload to read
    recv_payload_size = int.from_bytes(recv_payload_size_bytes, byteorder='little')
    # Read the JSON payload of the response
    recv_payload_json = sock.recv(recv_payload_size)
    # Deserialise the JSON payload into a python object. This is the response!
    recv_payload = json.loads(recv_payload_json)
    print(f"Received response: {recv_payload}")
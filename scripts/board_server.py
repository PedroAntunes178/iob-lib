#!/usr/bin/env python3

import time
import socket

# Define the server's IP and port
HOST = 'localhost'  # Listen on all available interfaces
PORT = 50007  # Use a non-privileged port
DEFAULT_GRAB_TIMEOUT = 300  # 5 minutes
SOCKET_TIMEOUT = 1  # 1 second for socket blocking operations

# Initialize the board status and user name
board_status = 'idle'
user_name = ''
grab_timeout = DEFAULT_GRAB_TIMEOUT
timer = time.time()

# Start the server
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print('Server is ready to receive requests...')
    # timeout accept and recv
    s.settimeout(SOCKET_TIMEOUT) 
    while True:
        try:
            conn, addr = s.accept()
        except TimeoutError:
            continue
        with conn:
            print('Connected by', addr)
            data = conn.recv(1024)
            if not data:
                continue
            data = data.decode()
            if data == 'query':
                if board_status == 'idle':
                    response = 'idle'
                else:
                    response = f'{board_status} {user_name} for {grab_timeout} seconds'
                conn.sendall(response.encode())
            elif data.startswith('grab'):
                try:
                    grabbed_user_name = data.split()[1]
                    if board_status == 'idle':
                        board_status = 'grabbed'
                        user_name = grabbed_user_name
                        try:
                            grab_timeout = int(data.split()[2])
                        except IndexError:
                            grab_timeout = DEFAULT_GRAB_TIMEOUT
                        timer = time.time()
                        response = f'grabbed for {grab_timeout} seconds'
                    else:
                        response = 'Board is busy; try again later.'
                except IndexError:
                    response = 'missing username'
                conn.sendall(response.encode())
            elif data.startswith('release'):
                try:
                    released_user_name = data.split()[1]
                    if released_user_name == user_name:
                        board_status = 'idle'
                        user_name = ''
                        response = 'released'
                    else:
                        response = 'Access denied'
                except IndexError:
                    response = 'missing username'
                conn.sendall(response.encode())

        if time.time() - timer >= grab_timeout:
            board_status = 'idle'
            user_name = ''
            timer = time.time()

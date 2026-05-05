import serial
import time
from pathlib import Path


PORT = "COM4"
BAUD = 115200

INSTRUCTIONS = "test_bin/AsciiOut"

CHAR_DELAY = 0.002
LINE_DELAY = 0.01
READ_TIME = 0.25
CPU_EXECUTE_DELAY = 0.25
READ_LOOP_DELAY = 0.25

def load_commands(path):
    commands = []

    for line in Path(path).read_text().splitlines():
        line = line.strip()

        # Skip empty lines and comments
        if not line or line.startswith("#"):
            continue

        commands.append(line)

    return commands

def send_slowly(ser, text):
    for ch in text:
        ser.write(ch.encode("ascii"))
        ser.flush()
        time.sleep(CHAR_DELAY)

def read_available(ser, duration=READ_TIME):
    end = time.time() + duration
    data = bytearray()

    while time.time() < end:
        waiting = ser.in_waiting
        if waiting:
            data.extend(ser.read(waiting))
        time.sleep(0.01)

    return bytes(data)

def print_response(response):
    if response:
        print("rx ascii:", response.decode("ascii", errors="replace"))

def send_command(ser, cmd, read_time=READ_TIME):
    send_slowly(ser, cmd + "\r")
    print("sent:", cmd)

    response = read_available(ser, duration=read_time)
    print_response(response)

    return response

commands = load_commands(INSTRUCTIONS)

with serial.Serial(PORT, BAUD, timeout=0.05) as ser:
    time.sleep(1)
    ser.reset_input_buffer()
    ser.reset_output_buffer()

    print(f"Loading commands from {INSTRUCTIONS}...")

    for cmd in commands:
        if cmd.lower().startswith("wait"):
            parts = cmd.split()

            if len(parts) == 2:
                delay = float(parts[1])
            else:
                delay = CPU_EXECUTE_DELAY

            print(f"waiting {delay} seconds...")
            time.sleep(delay)
            continue

        send_command(ser, cmd)
        time.sleep(LINE_DELAY)

    print("Program loaded.")
    print(f"Waiting {CPU_EXECUTE_DELAY} seconds before read loop...")
    time.sleep(CPU_EXECUTE_DELAY)

    print("Starting continuous read loop. Press Ctrl+C to stop.")

    while True:
        send_command(ser, "r", read_time=1.0)
        time.sleep(READ_LOOP_DELAY)
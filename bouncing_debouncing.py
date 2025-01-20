import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np

# Parameters
time_step = 0.001  # Time step in seconds
total_time = 0.6    # Total simulation time in seconds
debounce_delay = 0.1  # Debounce delay in seconds
decay_rate = 0.6  # Rate of decay for bouncing signal amplitude

# Generate time array
time = np.arange(0, total_time, time_step)

# Simulate bouncing behavior with decay
def simulate_bounce_decay(signal_length, bounce_duration, bounces, decay_rate):
    signal = np.zeros(signal_length)
    bounce_time_steps = int(bounce_duration / time_step)
    for i in range(bounces):
        start = i * bounce_time_steps
        end = start + bounce_time_steps // 2
        if end < signal_length:
            amplitude = np.exp(-i * decay_rate)  # Exponential decay for amplitude
            signal[start:end] = amplitude
    return signal

# Generate switch bouncing signal with decay
bouncing_signal = simulate_bounce_decay(len(time), 0.05, 10, decay_rate)

# Apply debouncing logic
debounced_signal = np.zeros_like(bouncing_signal)
stable_state = 0
last_change_time = -debounce_delay

for i, t in enumerate(time):
    if bouncing_signal[i] > 0.5 and stable_state == 0:  # Threshold for bounce detection
        if t - last_change_time > debounce_delay:
            stable_state = 1
            last_change_time = t
    elif bouncing_signal[i] <= 0.5 and stable_state == 1:
        if t - last_change_time > debounce_delay:
            stable_state = 0
            last_change_time = t
    debounced_signal[i] = stable_state

# Animation setup
fig, ax = plt.subplots()
ax.set_xlim(0, total_time)
ax.set_ylim(-0.1, 1.1)
ax.set_xlabel("Time (s)")
ax.set_ylabel("Signal")
ax.set_title("Switch Bouncing with Decay and Debouncing")
bouncing_line, = ax.plot([], [], label="Bouncing Signal (with Decay)", lw=2)
debounced_line, = ax.plot([], [], label="Debounced Signal", lw=2)
ax.legend()

def init():
    bouncing_line.set_data([], [])
    debounced_line.set_data([], [])
    return bouncing_line, debounced_line

def update(frame):
    bouncing_line.set_data(time[:frame], bouncing_signal[:frame])
    debounced_line.set_data(time[:frame], debounced_signal[:frame])
    return bouncing_line, debounced_line

ani = FuncAnimation(fig, update, frames=len(time), init_func=init, blit=True, interval=10)
plt.show()
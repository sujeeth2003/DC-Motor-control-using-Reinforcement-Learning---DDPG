# DC Motor Control Using Reinforcement Learning (DDPG)

This project implements a Reinforcement Learning based control system for a DC motor using the MATLAB Reinforcement Learning Toolbox and Simulink. A Deep Deterministic Policy Gradient (DDPG) actor–critic agent is trained in simulation and the same framework is successfully applied to a real-world tank height control system using NI DAQ hardware.

## Project Overview

The goal of this project is to design and train a reinforcement learning agent capable of learning an optimal continuous control policy for a DC motor system. The agent observes system error signals and outputs a continuous control action. The trained agent was later adapted to control a physical tank level system using a pneumatic valve.

## Repository Structure

```text
DC-Motor-control-using-Reinforcement-Learning---DDPG/
├── README.md
├── motorcodelast.m
└── motorsim.slx
```
## Requirements

- MATLAB (R2022a or later recommended)
- Reinforcement Learning Toolbox
- Simulink
- Deep Learning Toolbox

**For real-world implementation**
- NI DAQ hardware
- Pneumatic valve and tank setup

---

## Observation and Action Space

### Observations
- Integrated error
- Error
- Measured height or motor output

### Action
- Continuous control signal  
- Range: 0 to 12

---

## How to Run

### Open the .m file

```matlab
Run motorcodelast.m
```
## Training the Agent

- Set the RL Agent block to **training mode**
- Ensure no pre-trained agent is loaded
- Run the training script from the `motorcodelast` file

## Simulation Using a Trained Agent

- Set the RL Agent block to **inference mode**
- Load the trained agent
- Run the simulation

## Agent Details

### Algorithm
- Deep Deterministic Policy Gradient (DDPG)

### Actor Network
- Fully connected neural network
- Tanh activation
- Continuous action output

### Critic Network
- Separate state and action input paths
- Combined using an addition layer
- Outputs a scalar Q-value

### Training Features
- Experience replay buffer
- Target networks
- Exploration noise with decay

## Real-World Implementation

The reinforcement learning agent was deployed on a real-world tank level control system. The agent controlled a pneumatic valve, received tank height feedback through NI DAQ hardware, and successfully regulated the tank level in real time. This demonstrates effective simulation-to-real transfer.

## Contributors
- Madhav Srinath – [GitHub Profile](https://github.com/MadhavSrinath22)
- Vivek Balamurugan

## Author

Sujeeth S  
Electronics and Instrumentation Engineering  
Reinforcement Learning and Control Systems

## License

Provided for academic and learning purposes.

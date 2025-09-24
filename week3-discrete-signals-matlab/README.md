# about description below, actualy the core idea  from the GPT
# week3-discrete-signals-matlab
# Unit Impulse:Models a “sample at one time index”; system impulse response
# Unit Step:Turns on a system/input at n=0  
# Unit Ramp:Tests system response to linearly increasing inputs.
# Right-Sided Exponential:Fundamental LTI mode; appears in natural/forced responses
# Signum:Simple nonlinearity; useful in examples and symmetry checks.

<img width="914" height="667" alt="image" src="https://github.com/user-attachments/assets/4303a8da-3519-40b7-9531-8c9a02e6ac5d" />
# Discrete-time sinc (scaled)
This plot shows a scaled discrete-time sinc sequence，The scaling by 𝐿 spreads the main lobe around n=0 and prevents all integer samples (except n=0) from landing on zeros, so you see a tall central lobe and decaying oscillatory side lobes on both sides.
<img width="695" height="524" alt="image" src="https://github.com/user-attachments/assets/cd1ca42e-fd76-4834-862a-4a6152fdc8a8" />

## so How to run

1. Open MATLAB.
2. Put `discrete_signals.m` in your working directory.
3. Run:
   ```matlab
   discrete_signals



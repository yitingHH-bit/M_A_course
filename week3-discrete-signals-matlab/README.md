# about description below, actualy the core idea  from the GPT
# week3-discrete-signals-matlab

# Unit Impulse:Models a “sample at one time index”; system impulse response
<img width="515" height="250" alt="image" src="https://github.com/user-attachments/assets/69b03664-6bd4-484f-a87f-08f48299c6db" />
# Unit Step:Turns on a system/input at n=0  
<img width="526" height="253" alt="image" src="https://github.com/user-attachments/assets/3a6d03c9-657e-47c6-9ba6-d6da7dc2b895" />
# Unit Ramp:Tests system response to linearly increasing inputs
<img width="511" height="262" alt="image" src="https://github.com/user-attachments/assets/84735eb1-4b2c-4b0d-90da-6cfba4bf7c56" />
# Right-Sided Exponential:Fundamental LTI mode; appears in natural/forced responses
<img width="513" height="267" alt="image" src="https://github.com/user-attachments/assets/21293d99-599e-4420-b2c6-e4eb7ca06b2d" />
# Signum:Simple nonlinearity; useful in examples and symmetry checks
<img width="511" height="263" alt="image" src="https://github.com/user-attachments/assets/53512cc0-02af-4a63-8449-a26c32503ace" />
# Discrete-time sinc (scaled)
This plot shows a scaled discrete-time sinc sequence，The scaling by 𝐿 spreads the main lobe around n=0 and prevents all integer samples (except n=0) from landing on zeros, so you see a tall central lobe and decaying oscillatory side lobes on both sides.
<img width="695" height="524" alt="image" src="https://github.com/user-attachments/assets/cd1ca42e-fd76-4834-862a-4a6152fdc8a8" />

## so How to run

1. Open MATLAB.
2. Put `discrete_signals.m` in your working directory.
3. Run:
   ```matlab
   discrete_signals



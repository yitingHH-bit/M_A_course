# week3-discrete-signals-matlab

MATLAB script to generate and visualize classic **discrete-time signals**:

- Unit Impulse `δ[n]`
- Unit Step `u[n]`
- Unit Ramp `r[n] = n·u[n]`
- Exponential `x[n] = a^n u[n]` (default `a=0.8`)
- Signum `sgn[n]`
- Discrete sinc `sinc_d[n] = sin(πn)/(πn)`, with `sinc_d[0]=1`

## How to run

1. Open MATLAB.
2. Put `discrete_signals.m` in your working directory.
3. Run:
   ```matlab
   discrete_signals


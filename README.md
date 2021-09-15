# stochastic-processes-in-Finance-
Modelling of some of the most popular stochastic processes in Finance: i) Geometric Brownian Motion; ii) Ornstein-Uhlenbeck process; iii) Feller-square root process and iv) Brownian Bridge.

## 1. Geometric Brownian motion 
A geometric Brownian motion (GBM) is a continuous-time stochastic process in which the logarithm of the random variables follows a Brownian motion (also called a Wiener process) with drift. It is an important example of stochastic processes satisfying a stochastic differential equation (SDE); in particular, it is used in mathematical finance to model stock prices in the Black–Scholes model.

A stochastic process <img src="https://render.githubusercontent.com/render/math?math=S_{t}"> is said to follow a GBM if it satisfies the following stochastic differential equation (SDE): <img src="https://render.githubusercontent.com/render/math?math=dS_{t}=\mu S_{t}\,dt%2B\sigma S_{t}\,dW_{t}">, where Wt is a Weiner process.

Some of the arguments for using GBM to model stock prices are:

- The expected returns of GBM are independent of the value of the process (stock price), which agrees with what we would expect in reality.
- A GBM process only assumes positive values, just like real stock prices.
- A GBM process assumes that the stock price follows a random walk process with a predictable component given by the drift.

However, GBM is not a completely realistic model, in particular it falls short of reality in the following points:
- In real stock prices, volatility changes over time, but in GBM, volatility is assumed constant. It can be adjusted using a stochastic volatility model.
- In real life, stock prices often show jumps caused by unpredictable events or news, but in GBM, the path is continuous (no discontinuity). It can be adjusted using stochastic processes with jumps.

### We have included Matlab code that does the following:
- Models GBM using the discretised Euler-Maruyama method
- Implemented Monte Carlo Simulations to generate various paths and take their mean. See fig below
![](Images/gbm1.jpg)
- Plotted the probability density function of the GBM at different times. Random variable in a GBM model follows a log-normal distribution.
![](Images/gbm2.jpg)

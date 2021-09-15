%% Simulate a geometric Brownian motion
% dS = mu*S*dt + sigma*S*dW

% Define parameters and time grid
clear all % clear all variables from memory
npaths = 20000; % number of paths
T = 1; % time horizon
nsteps = 200; % number of time steps
dt = T/nsteps; % time step
t = 0:dt:T; % observation times
mu = 0.2; sigma = 0.4; % model parameters
S0 = 1; % initial stock price

%% Compute the increments of the arithmetic Brownian motion X = log(S/S0)
dX = (mu-0.5*sigma^2)*dt + sigma*sqrt(dt)*randn(npaths,nsteps);

% Accumulate the increments
X = [zeros(npaths,1) cumsum(dX,2)];

% Transform to geometric Brownian motion
S = S0*exp(X);

% Compute the expected path of the GBM
EX = exp(mu*t);

%% Plot the expected, mean and sample paths of the GBM
close all
figure(1)
plot(t,EX,'k',t,mean(S),':k',t,S(1:1000:end,:),t,EX,'k',t,mean(S),':k')
legend('Expected path','Mean path')
xlabel('t')
ylabel('X')
ylim([0,2.5])
title('Paths of a geometric Brownian motion dS = \muSdt + \sigmaSdW')
print('-dpdf','gbppaths.pdf')

% Plot the probability density function of the GBM at different times
figure(2)

subplot(3,1,1)
% [h,x] = hist(S(:20),100);
% f = h/(sum(h)*(x(2)-x(1)));
% bar(x,f)
histogram(S(:,20),0:0.035:3.5,'normalization','pdf');
ylabel('f_X(x,0.15)')
xlim([0,3.5])
ylim([0,3.5])
title('Probability density function of a geometric Brownian motion at different times')

subplot(3,1,2)
% [h,x] = hist(S(:,80),100);
% f = h/(sum(h)*(x(2)-x(1)));
% bar(x,f)
histogram(S(:,80),0:0.035:3.5,'normalization','pdf');
xlim([0,3.5])
ylim([0,3.5])
ylabel('f_X(x,0.4)')

subplot(3,1,3)
% [h,x] = hist(S(:,end),100);
% f = h/(sum(h)*(x(2)-x(1)));
% bar(x,f)
histogram(S(:,end),0:0.035:3.5,'normalization','pdf');
xlim([0,3.5])
ylim([0,3.5])
xlabel('x')
ylabel('f_X(x,1)')

print('-dpdf','gbpdensities.pdf')
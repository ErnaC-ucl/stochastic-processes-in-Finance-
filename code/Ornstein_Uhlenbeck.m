%% Simulate an Ornstein-Uhlenbeck process
% dX = alpha*(mu-X)*dt + sigma*dW

% Define the parameters and the time grid
npaths = 20000; % number of paths
T = 1; % time horizon
nsteps = 200; % number of time steps
dt = T/nsteps; % time step
t = (0:dt:T).'; % observation times
alpha = 5; mu = 0.07; sigma = 0.07; % model parameters
X0 = 0.03; % initial value

%% Allocate and initialise all paths
X = [X0*ones(1,npaths);zeros(nsteps,npaths)];

% Sample standard Gaussian random numbers
N = randn(nsteps,npaths);

% Compute the standard deviation for a time step
%sdev = sigma*sqrt(dt); % plain Euler-Maruyama
sdev = sigma*sqrt((1-exp(-2*alpha*dt))/(2*alpha)); % Euler-M. with analytic moments

% Compute and accumulate the increments
for i = 1:nsteps
    %X(i+1,:) = X(i,:) + alpha*(mu-X(i,:))*dt + sdev*N(i,:); % plain Euler-M.
    X(i+1,:) = mu+(X(i,:)-mu)*exp(-alpha*dt) + sdev*N(i,:); % Euler-M. with a. m.
end

% Compute the expected path
EX = mu+(X0-mu)*exp(-alpha*t);

%% Plot the expected/mean/sample paths and mu
close all
figure(1)
plot(t,EX,'k',t,mean(X,2),'k:',t,mu*ones(size(t)),'k--',t,X(:,1:1000:end),t,EX,'k',t,mean(X,2),'k:',t,mu*ones(size(t)),'k--')
legend('Expected path','Mean path','\mu')
xlabel('t')
ylabel('X')
sdevinfty = sigma/sqrt(2*alpha);
ylim([mu-4*sdevinfty,mu+4*sdevinfty])
title('Paths of an Ornstein-Uhlenbeck process dX = \alpha(\mu-X)dt + \sigmadW')
print('-dpdf','oupaths.pdf')

%% Plot the variance
figure(2)
plot(t,sigma^2/(2*alpha)*(1-exp(-2*alpha*t)),'r',t,sigma^2*t,'g', ...
    t,sigma^2/(2*alpha)*ones(size(t)),'b',t,var(X,0,2),'m')
legend('Theory','\sigma^2t','\sigma^2/(2\alpha)','Sampled','Location','SouthEast')
xlabel('t')
ylabel('Var(X)')
ylim([0 0.0006])
title('Variance of an Ornstein-Uhlenbeck process')
print('-dpdf','ouvariance.pdf')

%% Plot the mean absolute deviation
figure(3) %  +(mu-X0)*alpha*t
plot(t,sigma*sqrt((1-exp(-2*alpha*t))/(pi*alpha))+sqrt(pi/2)*(mu-X0)*(1-exp(-alpha*t))/2,'r', ...
    t,sigma*sqrt(2*t/pi),'g',t,(sigma/sqrt(pi*alpha)+sqrt(pi/2)*(mu-X0))*ones(size(t)),'b',t,mean(abs(X-X0),2),'mo')
legend('Theory','\sigma\sqrt{2t/\pi}+\alpha(\mu-X_0)t','\sigma^2/(\pi\alpha)','Sampled','Location','SouthEast')
xlabel('t')
ylabel('Var(X)')
%ylim([0 0.0006])
title('Mean absolute deviation of an Ornstein-Uhlenbeck process')
print('-dpdf','ouvariance.pdf')

%% Compute and plot the probability density function at different times
x = linspace(-0.02,0.14,200)';
t2 = [0.05 0.1 0.2 0.4 1];
EX2 = mu+(X0-mu)*exp(-alpha*t2);
sdev = sigma*sqrt((1-exp(-2*alpha*t2))/(2*alpha));
f = zeros(length(x),length(t2));
for i = 1:length(t2)
    f(:,i) = pdf('norm',x,EX2(i),sdev(i));
end
figure(4)
plot(x,f)
legend('t = 0.05','t = 0.10','t = 0.20','t = 0.40','t = 1.00')
xlabel('x')
ylabel('f_X(x,t)')
title('Probability density function of an Ornstein-Uhlenbeck process at different times')
print('-dpdf','oudensities.pdf')

%% Compute and plot the autocovariance function
C = zeros(2*nsteps+1,npaths);
for j = 1:npaths
    C(:,j) = xcorr(X(:,j)-EX,'unbiased');
end
C = mean(C,2);
figure(5)
plot(t,sigma^2/(2*alpha)*exp(-alpha*t),'r',t,C(nsteps+1:end),'b',t,sigma^2/(2*alpha)*ones(size(t)),'g',t,mean(var(X,0,2))*ones(size(t)),'c')
xlabel('\tau')
ylabel('C(\tau)')
legend('Theory','Sampled','Var for infinite t','Average sampled Var','Location','East')
title('Autocovariance function of an Ornstein-Uhlenbeck process')
print('-dpdf','ouautocov.pdf')

%% Plot the autocorrelation function
figure(6)
plot(t,exp(-alpha*t),'r',t,C(nsteps+1:end)/C(nsteps+1),'b')
xlabel('\tau')
ylabel('c(\tau)')
legend('Theory','Sampled')
title('Autocorrelation function of an Ornstein-Uhlenbeck process')
print('-dpdf','ouautocorr.pdf')
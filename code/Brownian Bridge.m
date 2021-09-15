%% Simulate a Brownian bridge
% dX = (b-X)/(T-t)*dt + sigma*dW

% Define parameters and time grid
npaths = 20000; % number of paths
T = 1; % time horizon
nsteps = 200; % number of time steps
dt = T/nsteps; % time step
t = 0:dt:T; % observation times
sigma = 0.3; % volatility
a = 0.8; % initial value
b = 1; % final value
%% Allocate and initialise all paths (method 1)

%X = [a*ones(1,npaths); zeros(nsteps-1,npaths); b*ones(1,npaths)];

% Compute the Brownian bridge (method 1)
%for i = 1:nsteps-1
%     X(i+1,:) = X(i,:) + (b-X(i,:))/(nsteps-i+1) + sigma*sqrt(dt)*randn(1,npaths);
%end
%% Compute the increments of an arithmetic Brownian motion (method 2-Equivalent to method 1)

dW = sigma*sqrt(dt)*randn(nsteps,npaths);

% Accumulate the increments (method 2)
W = cumsum([a*ones(1,npaths); dW]);

% Compute the Brownian bridge: X(t) = W(t) + (b-W(T))/T*t (method 2)
X = W + repmat(b-W(end,:),nsteps+1,1)/T.*repmat(t',1,npaths);
%% Compute the expected path

EX = a + (b-a)/T*t;

% Plot the expected, mean and sample paths
figure(1)
plot(t,EX,'k',t,mean(X,2),':k',t,X(:,1:1000:end),t,EX,'k',t,mean(X,2),':k')
legend('Expected path','Mean path')
xlabel('t')
ylabel('X')
%sdevmax = sigma*sqrt(T)/2;
%ylim([(a+b)/2-4*sdevmax (a+b)/2+4*sdevmax])
title('Paths of a Brownian bridge dX = ((b-X)/(T-t))dt + \sigmadW')
print('-dpdf','bbpaths.pdf')
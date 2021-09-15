%% Simulate a Feller square-root process
% dX = alpha*(mu-X)*dt + sigma*sqrt(X)*dW
% Used in the Cox-Ingersoll-Ross model and
% in the Heston stochastic volatility model

% Define parameters and time grid
npaths = 20000; % number of paths
T = 1; % time horizon
nsteps = 200; % number of time steps
dt = T/nsteps; % time step
t = 0:dt:T; % observation times
alpha = 5; mu = 0.07; sigma = 0.265; % model parameters
X0 = 0.03; % initial value
Feller_ratio = 2*alpha*mu/sigma^2 % for output only

%% Allocate and initialise all paths
X = [X0*ones(1,npaths);zeros(nsteps,npaths)];

% Sample standard Gaussian random numbers
N = randn(nsteps,npaths);

% Degrees of freedom of the non-central chi square distribution
%d = 4*alpha*mu/sigma^2; % exact method

% Compute and accumulate the increments
a = sigma^2/alpha*(exp(-alpha*dt)-exp(-2*alpha*dt)); % Euler-Maruyama with analytic moments
b = mu*sigma^2/(2*alpha)*(1-exp(-alpha*dt))^2; % Euler-Maruyama with analytic moments
%k = sigma^2*(1-exp(-alpha*dt))/(4*alpha); % exact method
for i = 1:nsteps
    %X(i+1,:) = X(i,:) + alpha*(mu-X(i,:))*dt + sigma*sqrt(X(i,:)*dt).*N(i,:); % plain Euler-Maruyama
    X(i+1,:) = mu+(X(i,:)-mu)*exp(-alpha*dt) + sqrt(a*X(i,:)+b).*N(i,:); % Euler-Maruyama with a.m.
    %if X(i+1,:) < 0
    %    X(i+1,:) = 0;
    %end
    %X(i+1,:) = X(i+1,:).*(X(i+1,:)>=0);
    X(i+1,:) = max(X(i+1,:),zeros(1,npaths));
    %lambda = 4*alpha*X(i,:)/(sigma^2*(exp(alpha*dt)-1)); % exact method
    %X(i+1,:) = icdf('ncx2',rand(1,npaths),d,lambda)*k; % exact method
end

% Compute the expected path
EX = mu + (X0-mu)*exp(-alpha*t);

%% Plot the expected, mean and sample paths
figure(1)
plot(t,EX,'k',t,mean(X,2),':k',t,mu*ones(size(t)),'k--',t,X(:,1:1000:end),t,EX,'k',t,mean(X,2),':k')
legend('Expected path','Mean path','\mu')
xlabel('t')
ylabel('X')
sdevinfty = sigma*sqrt(mu/(2*alpha));
ylim([-0.02 mu+4*sdevinfty])
title('Paths of a Feller square-root process dX = \alpha(\mu-X)dt + \sigmaX^{1/2}dW')
print('-dpdf','cirppaths.pdf')

%% Compute and plot the probability density function at different times
t2 = [0.05 0.1 0.2 0.4 1];
x = linspace(-0.02,mu+4*sdevinfty,200);
k = sigma^2*(1-exp(-alpha*t2))/(4*alpha);
d = 4*alpha*mu/sigma^2;
lambda = 4*alpha*X0./(sigma^2*(exp(alpha*t2)-1)); % non-centrality parameter
f = zeros(length(x),length(t2));
for i = 1:length(t2)
    f(:,i) = pdf('ncx2',x/k(i),d,lambda(i))/k(i);
end
figure(2)
plot(x,f)
xlabel('x')
ylabel('f_X(x,t)')
legend('t = 0.05','t = 0.10','t = 0.20','t = 0.40','t = 1.00')
title('Probability density function of a Feller square-root process at different times')
print('-dpdf','cirpdensities.pdf')
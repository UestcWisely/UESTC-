% The time period of the signal considered
Tf=0.5; 

% The sampling time period
Ts=1e-5;

t=0:Ts:Tf;
Num_iter=100000;

% The source signals
u1=0.1*sin(400*t).*cos(30*t);
u2=0.01*sign(sin(500*t+9*cos(40*t)));
u3=2*rand(1,length(t))-1;
u=[u1; u2; u3];

A=[0.56 0.79 -0.37; -0.75 0.65 0.86; 0.17 0.32 -0.48];

% Mixing the sources
x=A*u;

% Runs the Algorithm for 10 different initial weights
for r=1:10,

flag=0;

% error definition for convergence
error=1e-2;
nu=0.1;

% initialising the weights
W=0.1*rand(3,3);

% storing the initial weights
W_init((r-1)*3+1:r*3,1:3)=W;

for i=1:Num_iter,

% Demixing x with W
 y=W*x;

% The activation function
 f=(3/4)*y.^11+(25/4)*y.^9+(-14/3)*y.^7+(-47/4)*y.^5+(29/4)*y.^3;

 dW=(eye(3)-f*y')*W;

% The weight update
 W=W+nu*dW

% Break if Algorithm diverges
 if (sum(sum(isnan(W)))>0) flag=1; break; end
   max(max(abs(dW)));

% Break if Algorithm converges-- max weight update is less than error
 if (max(max(abs(dW)))<error & i>10) break; end;

end

% Number of iterations taken
if (~flag) num(r)=i; else num(r)=0; end

% store the final weights
W_end((r-1)*3+1:r*3,1:3)=W;
i
end

%save all values
save NUM8 num -ascii
save W_init8 W_init -ascii 
save W_end8 W_end -ascii 

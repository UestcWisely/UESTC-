% Demo of Hopfield network
% Hugh Pasika 1997

clc
clf

disp('The Hopfield Network - Demo 1 - Pattern Recall')
disp('----------------------------------------------')
disp(' ')
disp('This algorithm demonstates recall of a corrupted pattern.')
disp('The user is prompted for the input pattern and the noise level ')
disp('and well as an interval at which to show progress of the algorithm.')
disp(' ')
disp('Loading the digits.')
load hop_data
disp(' ')
disp('Hit a key to continue.')
figure(1)
hop_plotpats(P)
set(gcf,'Name','Hopfield Network - Input Patterns')
set(gcf,'Position',[16   445   568   427])
pause
disp(' ')

%----------------- Calculate Weight Matrix
disp('Calculating the weight matrix.')
 W=hop_stor(P);

%----------------- Select Input Pattern
pat=78;
while pat<1 | pat> 8
fprintf(1,'Select an input pattern to corrupt with noise according to\n')
pat=input('the number under it (1 to 8): ');
end
figure(1)
set(gcf,'Position',[11 653 645 244])
set(gcf,'Name','Hopfield Network - Recall')
clf
subplot(1,3,1)
hop_plotdig(P(:,pat),12,10,'Input Pattern')

%------------------ Input bit flip probability
pr=100;		% dummy variable to get loop started
while (pr <= 0) | (pr >= 1),
pr=input('Enter the probability of flipping a bit (0 to 1): ');
end
test_pat=hop_flip(P(:,pat),pr);
subplot(1,3,2)
hop_plotdig(test_pat,12,10)
xlabel('Corrupted Pattern')

%------------------ How often to view network state
u=100;	% dummy variable to get loop started
while (u < 1) | (u > 10),
u=input('How many iterations between viewing the network state (1 to 10): ');
end

disp('OK. Entering the recall phase. ')

subplot(1,3,3)
[s,c,M]=hop_test(W,test_pat,u);




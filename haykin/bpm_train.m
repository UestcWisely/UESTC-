function [W1, b1, W2, b2, ep_err, initAvErr, end_epoch]=bpm_train(P, hN, oN, inD, lr, mom, epochs, W1i, b1i, W2i, b2i, stop_crit)

% function [W1, b1, W2, b2, ep_err, initAvErr, end_epoch]=
%	bpm_train(P, hN, oN, inD, lr, mom, epochs, W1i, b1i, W2i, 
%		  b2i, stop_crit)
%
%   W1, W2, b1, b2 - weights, bias
%   ep_err	   - average error over epoch
%   initAvErr	- initial average error (before any training)
%   end_epoch	- if stop criteria is specified, this is the epoch the 
%		  algorithm quit at
%
%   P   -  rowwise training vectors with format 
%		[input1 input2 ... target1 target2 ..]
%   hN  -  number of hidden neurons		
%   oN  -  number of output neurons		
%   inD -  input dimension
%   lr  -  learning rate
%   mom -  momentum
%   epochs - number of epochs to train for
%   W1i, b1i, W2i, b2i - initial weights and biases - if set to zero 
%		routine initializes with random variables
%   stop_crit - percentage error change between epochs used as stopping 
%		criteria  - set to zero if routine is to run 
%		for 'epochs' epochs
%
% This function performs bp learning with momentum on a single hidden layer
% MLP. It returns the weights and biases as matrices giving the MSE after 
% each epoch. You can pass it an initial set of weights and biases if you
% so choose. The patterns should be row vectors. The non-linear function is
% the standard sigmoidal and is found in files bpm_phi.m and bpm_phi_d.m 
% (the derivative).
%
% [W1, b1, W2, b2, ep_err, a, end_ep]=bpm(P, 4, 2, 2, .1, .5, 5, 0,0,0,0,0);
%
% Hugh Pasika  June 1997

   pep_err=10;
   if (nargin ~= 12), fprintf(1,'Wrong number of input arguments. Exiting!\n\n'); break; end
   fprintf(1,'\nThe first time through, the percent change in average error is meaningless.\n\n')

%--------------------------------------------------------
% init network
%--------------------------------------------------------
   dflag=0;		
   [num_pats cP]=size(P); 

   W1   = rands(hN, inD+1);   	W2   = rands(oN, hN+1);
   dW1l = W1*0;      		dW2l = W2*0; 
   lr1  = lr*ones(size(W1));    lr2  = lr*ones(size(W2));

   %just for reference sake, determine the average error with the random weights
   for i=1:num_pats,
     input       = [P(i,1:inD) 1]';	target      = P(i, inD+1:inD+oN)';
     outHidden   = bpm_phi(W1*input);	outOutput   = bpm_phi(W2*[outHidden' 1]');
     outputError = target-outOutput;	errEpoch(i) = sqrt(sumsqr(outputError));
  end
  initAvErr=sum(errEpoch)/num_pats;
  fprintf('The initial mean squared error is: %g\n\n',initAvErr )

%--------------------------------------------------------
% entering training loop
%--------------------------------------------------------

   fprintf( 1, 'Training via Backprop with Momentum\n\n')
   epoch=1;
   dflag=0;
   while epoch < epochs+1 & dflag == 0,

      cc=clock;

      fprintf( 1, 'entering training loop for epoch %g of %g epochs\n',epoch, epochs);
      P=shuffle(P);

      for i=1:num_pats,
         input  = [P(i,1:inD) 1]';
         target = P(i,inD+1:inD+oN)';

         sumHidden   = W1*input;		outHidden   = bpm_phi(sumHidden);
         sumOutput   = W2*[outHidden' 1]';	outOutput   = bpm_phi(sumOutput);
         outputError = target-bpm_phi(sumOutput);	errEpoch(i) = sumsqr(outputError);

         dc  = bpm_phi_d(sumOutput) .* outputError;
         dW2 = lr2 .* dc(:,ones(hN+1,1)) .* [outHidden(:,ones(oN,1))' ones(oN,1)];

         db  = bpm_phi_d(sumHidden) .* ( sum( (W2(1:oN,1:hN)' .* dc(:,ones(1, hN))'),2)); 
         dW1 = lr1 .* db(:,ones(inD+1,1)) .* (input(:,ones(hN,1))');

         W1 = W1 + dW1 + mom*dW1l;	W2 = W2 + dW2 + mom*dW2l; 
         dW1l=dW1;     			dW2l=dW2;

      end

      ep_err(epoch)=sum(errEpoch)/num_pats;

      fprintf(1,'   mean square error:      %g\n', ep_err(epoch))
      fprintf(1,'   seconds to train epoch: %g\n',etime(clock,cc))

      diff_ep_err = 100*(pep_err-ep_err(epoch))/pep_err;
      fprintf(1,'Percent change in average error for epoch is: %g\n\n', diff_ep_err)

      if abs(diff_ep_err) < stop_crit, 
	fprintf(1,'Training ended due to delta error term being exceeded on epoch: %g\n\n',epoch)
	dflag=1;
        end_epoch = epoch;
      end
      pep_err=ep_err(epoch);	% save epoch_err for calculating epoch error on next iter
      epoch=epoch+1;

   end

   b1=W1(:,inD+1);    b2=W2(:,hN+1);     W1=W1(:,1:inD);    W2=W2(:,1:hN);







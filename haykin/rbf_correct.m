function p=rbf_correct(y,d)

% p - percent correct in two class problem
% y - output from testing phase
% d - desired output class (1 or 0 as defined in mk_data)

perr=sum((y(:,1) < y(:,2)) == d);
p=100*(perr)/size(y,1);

fprintf(1,'The percent correct is:  %5.2f.\n',p)

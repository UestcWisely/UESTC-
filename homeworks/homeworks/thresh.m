function M=thresh(A,ll,ul)

% M=thresh(A,ll,ul)
%
%  a little routine that thresholds a matrix or vector with 
%  a lower limit (ll) and an upper limit (ul)
%
%  Hugh Pasika 1996

M = (A<ll)*ll + (A>ul)*ul + (A>=ll & A<=ul).*A;



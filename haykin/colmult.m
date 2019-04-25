function B=colmult(A, vec)

cols=length(vec);
[rA cA]=size(A);

M=vec(ones(rA,1),:);

B=M.*A;
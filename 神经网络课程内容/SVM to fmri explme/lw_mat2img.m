function lw_mat2img(TPZmatrix)
% function lw_mat2imgn(TPZmatrix)
% 
% transform the MATLAB(*.mat) to Analysis (*.img,*.hdr)
% -------------------------------------------------------------------------
%%   input TPZmatrix that contains a results is a MATLAB variable 
%%     eg.TPZmatrix=64*64*23 
%%   
%     Code by Wei Liao£®¡ŒŒ∞£©,SLST, China.  
%     weiliao@yeah.net
% 
%     thansk for your appreciate!
%--------------------------------------------------------------------------

%%%%dimxyz=input('please input your dim x,y,z')
PG=spm_get(Inf,'*.img','Select images');
VO=spm_vol(PG(1,:));
% judge whether the result variable is equal to the template
aa=TPZmatrix;
[ix iy iz]=size(aa);
if ~all(VO.dim(1,1:3)==[ix iy iz])
    warndlg('dim not match, please select *.img file again', '!! Warning !!')
    return;
end;
% input your new filename(full filename!!!!!).e.g.input liaowei.img
files=input('please input your new img full filename:','s')
VO.fname=files;



spm_write_vol(VO,aa);
function W=gha_getweights(Image,epochs,pcs,mu)

mval = max(max(Image));
Sc   = round((Image/mval)*256);
Dat  = gha_chopstak(Sc,8,8)/256;

W=gha(Dat,epochs,pcs,mu);

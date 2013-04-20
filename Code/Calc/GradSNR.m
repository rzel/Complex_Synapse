function [ S, dSdWp,dSdWm ] = GradSNR( t, Wp, Wm, fp, w, varargin  )
%[S,GS]=GRADSNR(T,WP,WM,FP,w) Summary of this function goes here
%   T = time value
%   WP = potentiation transition rates
%   WM = depression transition rates
%   FP = Fraction of potentiation transitions
%   w = Weights of states (+/-1)

error(CheckSize(t,@isscalar));
error(CheckSize(Wp,@ismat));%matrix
error(CheckSize(Wp,@issquare));%square
error(CheckSize(Wm,@(x)samesize(Wp,x),'samesize(Wp)'));%also square matrix of same size
error(CheckSize(fp,@isscalar));
error(CheckValue(fp,@(x) inrange(x,0,1),'inrange(0,1)'));%fp in [0,1]
error(CheckSize(w,@iscol));
error(CheckValue(w,@(x) all(x.^2==1),'all w = +/-1'));

NoDiag=true;
thresh=1e-7;
varargin=assignApplicable(varargin);


q=Wp-Wm;
W=fp*q + Wm;

[u,qa]=eig(-W);
qa=diag(qa);
[qa,ix]=sort(qa);
u=u(:,ix);

%this method doesn't work when eigenvectors are nearly parallel

% Zinv=ones(length(w)) - W;
% p = ones(1,length(w))/Zinv;

%this method doesn't work when eigenvectors are nearly parallel

% Z=u * diag(1./[1;qa(2:end)]) / u;
% p=[1 zeros(1,length(qa)-1)] / u;
% p=p/sum(p);

%this method doesn't work when eigenvalues are nearly degenerate

[v,qb]=eig(-W');
qb=diag(qb);
[~,ix]=sort(qb);
v=conj(v(:,ix));
v=diag(1./diag(v'*u)) * v';
% v=inv(u);

Z=u * diag(1./[1;qa(2:end)]) * v;
p=v(1,:);
p=p/sum(p);

expLt=exp(-qa*t);
expWt=u*diag(expLt)*v;
% expWt=u*diag(expLt)/u;

% S=p*q*u*expLt*v*w;
S=p*q*expWt*w;

%deriv wrt q_ij
dSdq=((expWt*w)*p).';
if NoDiag
    dSdq=dSdq-diag(dSdq)*ones(1,length(w));
end

%deriv wrt W_ij, due to p
dSdp=((Z*q*expWt*w)*p).';
% dSdp=((Zinv\q*expWt*w)*p).';
%deriv wrt W_ij, due to expWt
%ref: http://dx.doi.org/10.1002/nme.263
FF=expLt*ones(1,length(w));
F=FF-FF.'+t*diag(expLt);
qa=qa*ones(1,length(w));
qa=qa.'-qa+eye(length(w));
%check for degenerate evals
degenerate= qa<thresh;
qa(degenerate)=1;
F(degenerate)=t*FF(degenerate);
%
F=F./qa;
dSdexpWt=(u*diag(v*w)*F*diag(p*q*u)*v).';
% dSdexpWt=(u*diag(u\w)*F*diag(p*q*u)/u).';
%deriv wrt W_ij
dSdW=dSdp+dSdexpWt;
if NoDiag
    dSdW=dSdW-diag(dSdW)*ones(1,length(w));
end

dSdWp=fp*dSdW+dSdq;
dSdWm=dSdW-dSdWp;

end

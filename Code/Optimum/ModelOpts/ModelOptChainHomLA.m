function [ newqv,A,ef ] = ModelOptChainHomLA( qv,sm,varargin)
%[newqv,A,ef]=MODELOPTCHAINHOMLA(qv,sm) run gradient descent on model to
%maximise A(s)
%   sm = Laplace param value
%   qv = nearest neighbour transition rates
%   A  = Laplace Transf value
%   ef = exit flag

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='ModelOptChainHomLA';
    p.StructExpand=true;
    p.KeepUnmatched=true;
    p.addParameter('UseDerivs',true,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOptChainHomLA','UseDerivs'));
    p.addParameter('DispExit',false,@(x) validateattributes(x,{'logical'},{'scalar'},'ModelOptChainHomLA','DispExit'));
    p.addParameter('TolFun',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainHomLA','TolFun'));
    p.addParameter('TolX',1e-10,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainHomLA','TolX'));
    p.addParameter('TolCon',1e-6,@(x) validateattributes(x,{'numeric'},{'scalar'},'ModelOptChainHomLA','TolCon'));
    p.addParameter('MaxIter',1000,@(x) validateattributes(x,{'numeric'},{'scalar','integer'},'ModelOptChainHomLA','MaxIter'));
    p.addParameter('Algorithm','interior-point',@(x) parsevalidatestring(x,{'trust-region-reflective','active-set','interior-point','sqp'},'ModelOptChainHomLA','MaxIter'));
    p.addParameter('Display','off',@(x) parsevalidatestring(x,{'off','iter','iter-detailed','notify','notify-detailed','final','final-detailed'},'ModelOptChainHomLA','Display'));
    p.addParameter('fp',0.5,@(x) validateattributes(x,{'numeric'},{'scalar','nonnegative','<=',1},'ModelOptChainHomLA','fp'));
end
p.parse(varargin{:});
r=p.Results;

qmin=zeros(size(qv));
% qmax=Inf(size(qv));
qmax=[];


options = optimset(p.Unmatched,'Algorithm',r.Algorithm,'Display',r.Display,...
    'TolFun', r.TolFun,...  % termination based on function value (of the derivative)
    'TolX', r.TolX,...
    'TolCon',r.TolCon,...
    'MaxIter',r.MaxIter, ...
    'largescale', 'on');

if r.UseDerivs
    options = optimset(options,'GradObj','on');
    [newqv,A,ef] = fmincon(@(y)OptFunGradChainHomLA(y,sm,r.fp),qv,...
        [],[],[],[],qmin,qmax,[],... 
        options);
else
    [newqv,A,ef] = fmincon(@(y)OptFunChainHomLA(y,sm,r.fp),qv,...
        [],[],[],[],qmin,qmax,[],... 
        options);
end
A=-A;



if r.DispExit
    disp(ExitFlagMsg(ef));
end

end


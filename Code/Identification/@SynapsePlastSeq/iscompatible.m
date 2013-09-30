function [ tf ] = iscompatible( simobj,modelobj )
%ISCOMPATIBLE are SynapseIdModel and SynapsePlastSeq compatible?
%   are indices in correct range?

tf = simobj.NumPlast<=modelobj.NumPlast &&...
    simobj.NumStates<=modelobj.NumStates &&...
    simobj.NumWvals<=modelobj.NumWvals ;
    


end


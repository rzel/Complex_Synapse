classdef SynapsePlastSeq
    %SYNAPSEPLASTSEQ Sequence of plasticity events.
    %   This class stores the results of a sequence of plasticity events:
    %   the type of each event (SYNAPSEPLASTSEQ.potdep) and the synaptic
    %   weight index before/after each event (SYNAPSEPLASTSEQ.readouts).
    
    properties (SetAccess=protected)%data
        %seq of plast types (indices of SynapseIdModel.M). default: []
        potdep=[],
        %sequence of synaptic weights (indices of SynapseIdModel.outProj). default: []
        readouts=[];
    end
    
    methods (Access=?SynapseIdModel) %setting data
        %
        function newobj=setPotDep(obj,newPotdep)
            newobj=obj;
            newobj.potdep=newPotdep;
        end
        %
        function newobj=setReadouts(obj,newReadouts)
            newobj=obj;
            newobj.readouts=newReadouts;
        end            
    end
    
    methods%validity etc.
        tf=isvalid(obj)
        tf=iscompatible(obj,modelobj)
    end
    
    methods %size info
        %
        function val=NumT(obj)
            val=length([obj.readouts]);
        end
        %
        function val=NumPlast(obj)
            val=max([obj.potdep]);
        end
        %
        function val=NumWvals(obj)
            val=max([obj.readouts]);
        end
        %
        tf=SameSizes(obj,otherobj)
    end
    
    methods
        newobj=GetRange(obj,range)
        obj3=plus(obj1,obj2)
        dwelltimes=DwellTimes(obj,varargin)
    end
    
    methods (Access=private)%for constructiuon
        %called by constructor
        copy=CopyProps(original,copy)
        toobj=CopyFields(fromstruct,toobj)
        [s,x] = assignToObject(s, x)
    end%methods
    
    methods%constructor
        function obj=SynapsePlastSeq(varargin)
            if nargin ~=0%false -> default constructor does nothing
                if nargin==2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
                    %true -> preallocate with default constructor doing nothing
                    obj(max(varargin{1},1),max(varargin{2},1))=SynapsePlastSeq;
                    if varargin{1}<1
                        obj(1,:)=[];
                    end
                    if varargin{2}<1
                        obj(:,1)=[];
                    end
                elseif nargin==1 && isnumeric(varargin{1}) && isrow(varargin{1})
                    siz=num2cell(varargin{1});
                    obj(siz{:})=SynapsePlastSeq;
                else
                    %
                    %default parameters:
                    %if we're copying another obj
                    [tempobj,varargin]=extractArgOfType(varargin,'SynapsePlastSeq');
                    %otherwise
                    if isempty(tempobj)
                        tempobj=obj;
                    end
                    %
                    %Set size of object:
                    %
                    if nargin>=2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
                        obj(varargin{1},varargin{2})=SynapsePlastSeq;
                    elseif nargin>=1 && isnumeric(varargin{1}) && isrow(varargin{1})
                        siz=num2cell(varargin{1});
                        obj(siz{:})=SynapsePlastSeq;
                    end%if nargin>=2
                    %
                    %set parameter values:
                    if ~isempty(Unmatched)
                        tempobj=CopyFields(Unmatched,tempobj);
                    end
                    [tempobj,varargin]=assignToObject(tempobj,varargin);
                    obj=CopyProps(tempobj,obj);
                    %
                    %Extract data:
                    %
                end% if nargin=2 && isnumeric(varargin{1}) && isnumeric(varargin{2})
            end%if nargin ~=0
        end%function SynapsePlastSeq
    end%methods constructor
    
end


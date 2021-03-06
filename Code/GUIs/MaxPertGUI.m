function MaxPertGUI(varargin)

persistent p
if isempty(p)
    p=inputParser;
    p.FunctionName='MaxPertGUI';
    p.StructExpand=true;
    p.KeepUnmatched=false;
    p.addParameter('nsteps',20,@(x)validateattributes(x,{'numeric'},{'scalar','integer'},'MaxPertGUI','nsteps'));
    p.addParameter('nstates',20,@(x)validateattributes(x,{'numeric'},{'scalar','integer'},'MaxPertGUI','nstates'));
end
p.parse(varargin{:});

%initial params
nsteps=p.Results.nstates;
nstates=p.Results.nstates;




%Initialise data (make them global)
qvec=ones(1,2*nstates-1)/2;
S.pertmin=0;
S.pertmax=1;
S.pertrow=1;
S.pertcol=3;
S.dopertp=1;
S.dopertm=1;
w=ones(2*nstates,1);
w(1:nstates)=-1;

%-------------------------------------------------------------------------
%Create figure
figure1 = figure('Units','normalized');

%Create axes 1
axes1 = axes('Parent',figure1,'OuterPosition',[0 0 0.5 1]);%left bottom width height


%-------------------------------------------------------------------------
%Make dummy handles
ph=zeros(1,2*nstates-1);
slh=ph;
sth=ph;
%-------------------------------------------------------------------------
%Create param panels
for i=1:2*nstates-1
    MakeSlider(i,(2*nstates+0.05-i)/(2*nstates),0.9/(2*nstates));
end
%-------------------------------------------------------------------------
%Create perturbation panel
    ph_p=uipanel(figure1,'Units','normalized',...
            'Position',[0.5 0 0.5 1/(2*nstates)]);%left bottom width height
    set(ph_p,'Title','Perturbation');
    %Make edit boxes
    MakeEditBox(ph_p,'pertrow','Row',0,0.5)
    MakeEditBox(ph_p,'pertcol','Column',0,0)
    MakeEditBox(ph_p,'pertmax','Max',1/3,0.5)
    MakeEditBox(ph_p,'pertmin','Min',1/3,0)
    %Make check boxes
    MakeCheckBox(ph_p,'dopertp','Potentiation',0.5);
    MakeCheckBox(ph_p,'dopertm','Depression',0);
%-------------------------------------------------------------------------
%Make initial plots
MakePlot;

%-------------------------------------------------------------------------

%  Callbacks for PertGui

    function sl_callback(source,~,which)
        qvec(which)=get(source,'Value');
        set(sth(which),'String',num2str(qvec(which)));
        MakePlot;
    end 

    function pb_callback(~,~,which)
        set(slh(which),'Value',0.5);
        sl_callback(slh(which),0,which);
    end

    function edb_callback(source,~,var)
        S.(var)=floor(str2double(get(source,'String')));
        MakePlot;
    end

    function chb_callback(source,~,var)
        S.(var)=get(source,'Value');
        MakePlot;
    end


%-------------------------------------------------------------------------

%  Utility functions

    function MakeSlider(which,bottom,height)
        ph(which)=uipanel(figure1,'Units','normalized',...
                'Position',[0.55 bottom 0.4 height]);%left bottom width height
        if which==2*nstates
            set(ph(which),'Title','Fraction of potentiation');
        else
            set(ph(which),'Title',['Transition rate: ' int2str(which) ' to ' int2str(which+1)]);
        end
        %slider
        slh(which)=uicontrol(ph(which),'Style','slider',...
                        'Max',1,'Min',0,'Value',qvec(which),...
                        'SliderStep',[0.02 0.2],...
                        'Units','normalized',...
                        'Position',[0.1 0.25 0.8 0.7],...
                        'Callback',{@sl_callback,which});
        %slider labels
        uicontrol(ph(which),'Style','text',...
                        'String','0',...
                        'Units','normalized',...
                        'Position',[0.1 0.05 0.08 0.2]);
        uicontrol(ph(which),'Style','text',...
                        'String','0.5',...
                        'Units','normalized',...
                        'Position',[0.475 0.05 0.05 0.2]);
        uicontrol(ph(which),'Style','text',...
                        'String','1',...
                        'Units','normalized',...
                        'Position',[0.85 0.05 0.05 0.2]);
        %button to zero slider
        uicontrol(ph(which),'Style','pushbutton',...
                        'String','1/2',...
                        'Units','normalized',...
                        'Position',[0.0 0.25 0.1 0.7],...
                        'Callback',{@pb_callback,which});
        %display value of slider
        sth(which)=uicontrol(ph(which),'Style','text',...
                        'String',num2str(qvec(which)),...
                        'Units','normalized',...
                        'Position',[0.9 0.25 0.1 0.7]);
    end%function MakeSlider

    function MakeEditBox(parent,var,title,x,y,varargin)
        %control
        uicontrol(parent,'Style','edit',...
            'String',num2str(S.(var),varargin{:}),...
            'Max',1,'Min',0,...
            'Units','normalized',...
            'Position',[x+1/6 y 1/6 1/2],...
            'Callback',{@edb_callback,var});
        %labels
        uicontrol(parent,'Style','text',...
            'String',title,...
            'Units','normalized',...
            'Position',[x y 1/6 1/2]);
    end%function MakeEditBox

    function MakeCheckBox(parent,var,title,y)
        uicontrol(parent,'Style','checkbox',...
              'String',title,...
              'Units','normalized',...
              'Value',S.(var),'Position',[0.7 y 0.29 0.5],...
              'Callback',{@chb_callback,var});
    end%function MakeCheckBox


    function MakePlot
        [Wp,Wm]=MakeSMS(qvec);
        [dWp,dWm]=MakePert(size(Wp),S.pertrow,S.pertcol);
        pertvals=S.pertmin:(S.pertmax-S.pertmin)/nsteps:S.pertmax;
        %update area plot
        fp=0:1/nsteps:1;
        maxp=zeros(size(fp));
        for j=1:length(fp)
            maxp(j)=MaxPert(Wp,Wm,S.dopertp*dWp,S.dopertm*dWm,fp(j),w,pertvals);
        end
        plot(fp,maxp,'Parent',axes1);
        xlabel(axes1,'f^+');
        ylabel(axes1,'Size of perturbation');
        title(axes1,'Optimal perturbation');
    end%function MakePlot



end %function IntGui
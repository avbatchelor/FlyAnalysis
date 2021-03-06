function PiezoSineScimStackTrace(h,handles,savetag,varargin)

if isfield(handles.trial,'imageNum') && ...
        ~(isfield(handles.trial,'scimStackTrace') || isfield(handles.trial,'roiScimStackTrace'))
    error('No scimStackTrace to plot')
end

% see also CurrentSineAverage
p = inputParser;
p.PartialMatching = 0;
p.addParameter('callingfile','',@ischar);
parse(p,varargin{:});

panl = panel(h);
panl.pack('v',{1/2 1/4 1/4})  % response panel, stimulus panel
panl.margin = [18 16 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;

if isempty(h) || ~ishghandle(h)
    h = figure(101); clf
else
    delete(get(h,'children'));
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

outname = 'sgsmonitor';
outunits = 'V';
stackTraceName = 'scimStackTrace';
if isfield(trial,'roiScimStackTrace') 
    stackTraceName = 'roiScimStackTrace';
    handles.trial.roiScimStackTrace = squeeze(handles.trial.roiScimStackTrace(:,:,1));
end


exp_t = handles.trial.exposureTimes;

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
panl.title([mfilename '\_' d '\_' fly '\_' cell '\_' trialnum])

%redtraces = nan(size(repmat(handles.trial.(stackTraceName)(:,1),1,length(trials))));
greentraces = handles.trial.roiScimStackTrace(:,2);

plot(panl(1).select(),exp_t,greentraces,'color',[0, 1 0],'tag',savetag); hold on

axis(panl(1).select(),'tight')
xlim([exp_t(1) exp_t(end)])
%ylim([80 150])
box(panl(1).select(),'off');
set(panl(1).select(),'TickDir','out');
ylabel(panl(1).select(),'%\DeltaF/F');

% plot(panl(2).select(),x,y,'color',[1, 0 0],'tag',savetag); hold on
% axis(panl(2).select(),'tight')
% xlim([exp_t(1) exp_t(end)])
% box(panl(2).select(),'off');
% set(panl(2).select(),'TickDir','out');
% ylabel(panl(2).select(),y_units);
% [prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
% panl.title([mfilename '\_' d '\_' fly '\_' cell '\_' trialnum])
% set(panl(2).select(),'tag','response_ax');

plot(panl(3).select(),x,trial.(outname)(1:length(x)),'color',[0 0 .5],'tag',savetag); hold on;
axis(panl(3).select(),'tight')
box(panl(3).select(),'off');
set(panl(3).select(),'TickDir','out');
xlim([exp_t(1) exp_t(end)])
set(panl(3).select(),'tag','stimulus_ax');
xlabel(panl(3).select(),'Time (s)');
ylabel(panl(3).select(),'pA');


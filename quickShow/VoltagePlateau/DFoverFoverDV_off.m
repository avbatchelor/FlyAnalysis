function varargout = DFoverFoverDV_off(h,handles,savetag)

if ~isfield(handles.trial.params,'combinedTrialBlock')
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
else
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'trialBlock'});
end
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

%% assuming the normal structure of the thing
plateau = .6-.46; %empirical
step_times = 0:handles.trial.params.plateauDurInSec:handles.trial.params.stimDurInSec;
voltageplateaux_off = zeros(length(trials),length(step_times));
dFoverFplateaux = zeros(length(trials),length(step_times));
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
eval(sprintf('protocol = %s();',trial.params.protocol));
if isfield(trial.params,'combinedTrialBlock')
    protocol.setParams('-q',rmfield(trial.params,'combinedTrialBlock'));
else
    protocol.setParams('-q',trial.params);
end
 
voltage_stim = protocol.getStimulus.voltage;

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    trial_vstim = voltage_stim + mean(voltage_stim(x<0));
    for s= 1:length(step_times)
        % take the points during the step, and after the step
        voltageplateaux_off(t,s) = mean(trial_vstim(x > step_times(s)+diff(step_times(1:2)) - plateau & x < step_times(s)+diff(step_times(1:2))));
        dFoverFplateaux(t,s) = mean(trial.dFoverF(trial.exposure_time > step_times(s)+diff(step_times(1:2)) - plateau & trial.exposure_time < step_times(s)+diff(step_times(1:2))));
    end
end
    
dV = voltageplateaux_off(:,2:2:end) - voltageplateaux_off(:,1:2:end);
[~,order] = sort(mean(dV));
dV = dV(:,order);
dF = dFoverFplateaux(:,2:2:end) - dFoverFplateaux(:,1:2:end);
dF = dF(:,order);

ax = subplot(1,1,1,'parent',h);
for r = 1:size(dV,1)
    plot(ax,dV(r,:),dF(r,:),'+','color',[.3 1 .3],'tag',savetag); hold on
end

plot(ax,mean(dV,1),mean(dF,1),'o','color',[0 .7 0],'MarkerFaceColor',[0 .7 0],'tag',savetag);


[~,dateID,flynum,cellnum,] = extractRawIdentifiers(trial.name);

title(ax,[dateID '.' flynum '.' cellnum ' (%\DeltaF/F) / \DeltaV '  sprintf('.%d',trials)]);
ylabel(ax,'%\DeltaF / F');
xlabel(ax,'\DeltaV (mV)')
set(ax,'xlim',[mean(get(ax,'xlim'))-.5*1.1*diff(get(ax,'xlim')) mean(get(ax,'xlim'))+.5*1.1*diff(get(ax,'xlim'))]);
% axis(ax,'tight')
% xlim([-.5 trial.params.stimDurInSec+ min(.5,trial.params.postDurInSec)])
plot(ax,get(ax,'xlim'),[0 0],':k');
plot(ax,[0 0],get(ax,'ylim'),':k');
box(ax,'off');
set(ax,'TickDir','out');

varargout = {h,dV,dF};
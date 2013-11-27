function fig = TransferFunctionOfLike(fig,handles,savetag)
% see also AverageLikeSongs

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+trials(1)); clf
else
end

set(fig,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
    outname = 'current';
    outunits = 'pA';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
    outname = 'voltage';
    outunits = 'mV';
end

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name);
    u(:,t) = trial.(outname);
end

yc = mean(y,2);
uc = mean(u,2);

yc = yc(x>=trial.params.stimDurInSec-3*1/trial.params.freq & x< trial.params.stimDurInSec);
uc = uc(x>=trial.params.stimDurInSec-3*1/trial.params.freq & x< trial.params.stimDurInSec);
t = x(x>=trial.params.stimDurInSec-3*1/trial.params.freq & x< trial.params.stimDurInSec);

[C, Lags] = xcorr(yc,uc,'coeff');
% figure(102);
% plot(Lags,C);

i_del = Lags(C==max(C));
t_del = t(i_del+1) - t(1);
figure(103); %clf
plot(t(1:end-i_del),uc(1:end-i_del),'color',[.7 .7 .7]), hold on
plot(t(1:end-i_del),yc(1:end-i_del),'color',[.7 .7 1]), hold on
%plot(t(1:end-i_del),yc(i_del+1:end)), hold on

arg = -t_del / (1/trial.params.freq) * 2*pi;
minfunc = @(x)mean(abs(yc(i_del+1:end)-x*uc(1:end-i_del)));
mag = fminsearch(minfunc ,1);
% plot(t(1:end-i_del),mag*uc(1:end-i_del),'color',[.7 0 0]), hold on

transfer = mag*(cos(arg) + i*sin(arg));

u_ideal = trial.params.amp*exp(i * (2*pi*trial.params.freq * t(1:end-i_del) - pi/2));

plot(t(1:end-i_del),real(u_ideal),'color',[1 .7 .7]), hold on
plot(t(1:end-i_del),real(transfer*u_ideal),'color',[1 .7 .7]), hold on

ax = subplot(3,1,[1 2],'parent',fig);
plot(ax,t,yc,'color',[1, .7 .7],'tag',savetag); hold on
plot(ax,t_h,real(h),'color',[.7 0 0],'tag',savetag);
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

ax = subplot(3,1,3,'parent',fig);
plot(ax,x,trial.(outname),'color',[0 0 1],'tag',savetag); hold on;
text(-.1,5.01,...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.amp) ' ' outunits],...
    'fontsize',7,'parent',ax,'tag',savetag)

box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
%ylim([4.5 5.5])

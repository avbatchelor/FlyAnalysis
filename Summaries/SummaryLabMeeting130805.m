% Lab Meeting 130805

%% first trial 130802 F1_C2
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_27.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_130802_F1_C2.mat')
plotcanvas = fig;
obj.trial.params = data(27);
savetag = 'delete';
% setupStimulus
obj.x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
voltage = obj.trial.voltage;
current = obj.trial.current;

% displayTrial
ax = subplot(5,1,4,'parent',plotcanvas);
if length(obj.trial.params.recmode)>6, mode = obj.trial.params.recmode(1:6);
else mode = 'IClamp';
end
switch mode
    case 'VClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

ax = subplot(5,1,[1 2 3],'parent',plotcanvas);
switch mode
    case 'VClamp'
        ylabel(ax,'I (pA)'); 
        line(obj.x,current,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
    case 'IClamp'
        ylabel(ax,'V_m (mV)'); 
        line(obj.x,voltage,'color',[1 0 0],'linewidth',1,'parent',ax,'tag',savetag);
end
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');

title(ax,'Sweep trial 27, durSweep=5, 14:17:5')

ax = subplot(5,1,[5],'parent',plotcanvas); 
voltagefft = fft(voltage);
f = obj.trial.params.sampratein/length(voltage)*[0:length(voltage)/2]; 
f = [f, fliplr(f(2:end-1))];
loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
hold(ax,'on');
box(ax,'off'); set(ax,'TickDir','out'); axis(ax,'tight');
ylabel(ax,'V^2'); %xlim([0 max(t)]);
xlabel(ax,'Time (s)'); 


%%  FR vs I
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_27.mat');

I = smooth(obj.trial.current,10000);
x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;

% plot(x,obj.trial.current); hold on
subplot(3,1,1)
plot(x,I,'r');

subplot(3,1,2)
plot(x,obj.trial.voltage),hold on

threshold = -40;
below = obj.trial.voltage <= threshold;
above = obj.trial.voltage > threshold;
cross_up = [below(1:end-1) & above(2:end); false];

plot(x(cross_up),threshold*cross_up(cross_up),'or');

window_t = .1;
noverlap_t = 0.1;
window = window_t * obj.trial.params.sampratein;
noverlap = noverlap_t * obj.trial.params.sampratein;

fr = [];
I = [];
istart = 0;
while istart + window < length(cross_up)
   fr(end+1) = sum(cross_up(istart+1:istart+window));
   I(end+1) = mean(obj.trial.current(istart+1:istart+window));
   istart = istart+noverlap;
end

fr = fr;

subplot(3,1,3)
plot(I,fr,'or');

%%  FR vs I 130802 F1_C2
fig = figure(102);
trials = [9:18, 24:27];
window_t = .1;
noverlap_t = 0.05;
frmat = [];
Imat = [];
for t = 1:length(trials)
    obj.trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat',trials(t));
    x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
   
    threshold = -40;
    below = obj.trial.voltage <= threshold;
    above = obj.trial.voltage > threshold;
    cross_up = [below(1:end-1) & above(2:end); false];

    window = window_t * obj.trial.params.sampratein;
    noverlap = noverlap_t * obj.trial.params.sampratein;
    
    fr = [];
    I = [];
    istart = 0;
    while istart + window < length(cross_up)
        fr(end+1) = sum(cross_up(istart+1:istart+window));
        I(end+1) = mean(obj.trial.current(istart+1:istart+window));
        istart = istart+noverlap;
    end
    %fr = fr/window_t;
    frmat(t,:) = fr;
    Imat(t,:) = I;
end
plot(Imat(:),frmat(:),'o'); hold on

%%  FR vs I 130701 F1_C1
fig = figure(101);
obj.trial = load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_Raw_01-Jul-2013_F1_C1_16.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_01-Jul-2013_F1_C1.mat')
obj.trial.params = data(16);

I = smooth(obj.trial.current,10000);
x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;

% plot(x,obj.trial.current); hold on
subplot(3,1,1)
plot(x,I,'r');

subplot(3,1,2)
plot(x,obj.trial.voltage),hold on

threshold = -40;
below = obj.trial.voltage <= threshold;
above = obj.trial.voltage > threshold;
cross_up = [below(1:end-1) & above(2:end); false];

plot(x(cross_up),threshold*cross_up(cross_up),'or');

window_t = .1;
noverlap_t = 0.1;
window = window_t * obj.trial.params.sampratein;
noverlap = noverlap_t * obj.trial.params.sampratein;

fr = [];
I = [];
istart = 0;
while istart + window < length(cross_up)
   fr(end+1) = sum(cross_up(istart+1:istart+window));
   I(end+1) = mean(obj.trial.current(istart+1:istart+window));
   istart = istart+noverlap;
end

fr = fr;

subplot(3,1,3)
plot(I,fr,'or');


%%  FR vs I 130701 F1_C1
fig = figure(102);
trials = [6:20];
window_t = .1;
noverlap_t = 0.05;
frmat = [];
Imat = [];
for t = 1:length(trials)
    obj.trial = pathload('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_Raw_01-Jul-2013_F1_C1_%d.mat',trials(t));
    load('C:\Users\Anthony Azevedo\Raw_Data\01-Jul-2013\01-Jul-2013_F1_C1\Sweep_01-Jul-2013_F1_C1.mat')
    obj.trial.params = data(trials(t));

    x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
   
    threshold = -40;
    below = obj.trial.voltage <= threshold;
    above = obj.trial.voltage > threshold;
    cross_up = [below(1:end-1) & above(2:end); false];

    window = window_t * obj.trial.params.sampratein;
    noverlap = noverlap_t * obj.trial.params.sampratein;
    
    fr = [];
    I = [];
    istart = 0;
    while istart + window < length(cross_up)
        fr(end+1) = sum(cross_up(istart+1:istart+window));
        I(end+1) = mean(obj.trial.current(istart+1:istart+window));
        istart = istart+noverlap;
    end
    %fr = fr/window_t;
    frmat(t,:) = fr;
    Imat(t,:) = I;
end
plot(Imat(:),frmat(:),'or');

%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Rest

fig = figure(103);
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    6:10,...
    1:5};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end


%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Hyper

fig = figure(103);
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    11:15,...
    6:8};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end

%% oscillatory power vs holding potential 130730 F1C1 130802 F1C2 Hyper

fig = figure(103);
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    21:25,...
    14:18};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end



%% Sensitivity to sine wave stimuli

fig = figure(103);
co = get(gca,'ColorOrder');

paths = {...
    'C:\Users\Anthony Azevedo\Raw_Data\130730\130730_F1_C1\Sweep_Raw_130730_F1_C1_%d.mat',...
    'C:\Users\Anthony Azevedo\Raw_Data\130802\130802_F1_C2\Sweep_Raw_130802_F1_C2_%d.mat'};
trialscell = {...
    21:5:35,...
    14:18};
for p = 1:length(paths)
    clear peakpower peakfreq Vm
    trials = trialscell{p};
    for t = 1:length(trials)
        obj.trial = pathload(paths{p},trials(t));
        x = ((1:obj.trial.params.sampratein*obj.trial.params.durSweep) - 1)/obj.trial.params.sampratein;
                
        Vm(t) = mean(obj.trial.voltage);
        voltagefft = fft(obj.trial.voltage-mean(obj.trial.voltage));
        voltagefft = voltagefft.*conj(voltagefft);
        f = obj.params.sampratein/length(voltage)*[0:length(voltage)/2];
        f = [f, fliplr(f(2:end-1))];
        %loglog(ax,f,voltagefft.*conj(voltagefft),'r','tag',savetag)
        [pptemp,pftemp] = max(voltagefft(f>10));
        peakpower(t) = pptemp;
        peakfreq(t) = f(pftemp+(sum(f<=10)+1)/2);
    end
    peakpowercell{p} = peakpower;
    peakfreqcell{p} = peakfreq;
    Vm_cell{p} = Vm;
    
    line(Vm,peakfreq,'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor','none');
    
    meanpp(p) = mean(peakpower);
    meanpf(p) = mean(peakfreq);
    meanVm(p) = mean(Vm);
    line(meanVm(p),meanpf(p),'linestyle','none','marker','o','markeredgecolor',co(p,:),'markerfacecolor',co(p,:));
end



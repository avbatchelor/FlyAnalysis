% drag and drop a file into matlab

[prot,datestr,fly,cellnum,trial,D] = extractRawIdentifiers(name);
stem = regexprep(name,'Acquisition','Raw_Data');
stem = regexprep(stem,prot,'%s');
stem = regexprep(stem,['_' trial '\.'],'_%d.');
stem = regexprep(stem,'\\','\\\');
cd(D)
[dfn,dfns] = createDataFileFromRaw(name);
for ind = 1:length(dfns)
    dfn = dfns{ind};
    data = load(dfn); data = data.data;
    dataOverview(data);
end

%% SealAndLeak
prot = 'SealAndLeak';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
f = blocknums;
cnt = 1;
for b = blocknums
    trial = load(sprintf(stem,data(1).protocol,data(find(blocks==b,1)).trial));
    [~,~,fig] = calculateSealMeasurements(trial,trial.params);
    proplist =  getpref('AnalysisFigures','calculateSealMeasurements');
    f(cnt) = figure(proplist{:});
    set(f(cnt),'tag',num2str(b));
    ch = copyobj(get(fig,'children'),f(cnt));
    cnt = cnt+1;
end
layout(f',sprintf('Seal Measurements Blocks: %s',sprintf('%d ', blocknums)),'close');

%% Sweep
prot = 'Sweep';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f P
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        obj.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = figure(50+cnt);
        f(cnt) = quickShow_Sweep(f(cnt),obj,'');
        clusters(cnt) = 1;
        [~,F,T,p] = trialSpectrogram(obj.trial,obj.trial.params);
        if exist('P','var')
            P = P+p;
        else P = p;
        end
        cnt = cnt+1;
    end
    f(cnt) = figure(50+cnt);
    clusters(cnt) = 2;

    ax = subplot(1,1,1,'parent',f(cnt));
    colormap(ax,'Hot') % 'Hot'
    surf(ax,T, F, 10*log10(P),'edgecolor','none');
    %set(ax, 'YScale', 'log');
    view(ax,0,90);
    axis(ax,'tight');
    ch = get(f(1),'children');
    set(ax,'xlim',get(ch(1),'xlim'));
    
    xlabel(ax,'Time (Seconds)'); ylabel(ax,'Hz');
    tags = getTrialTags(blocktrials,data);
    %title(ax,sprintf('%s Block %d: \\{%s\\}', [prot '.' d '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})));
    layoutClusters(f',clusters,sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');

end

%% PiezoStep
prot = 'PiezoStep';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSteps([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,3,2)';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoSquareWave
prot = 'PiezoSquareWave';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSquareWaves([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,1,length(data(bt).displacements))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}',[prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoSine
prot = 'PiezoSine';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSines([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,length(data(bt).displacements),length(data(bt).freqs))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoCourtshipSong
prot = 'PiezoCourtshipSong';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSongs([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,1,length(data(bt).displacements))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end


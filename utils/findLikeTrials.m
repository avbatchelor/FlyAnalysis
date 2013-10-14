function varargout = findLikeTrials(varargin)
% [nums,inds] = findLikeTrials('name',name,'trial',trial,'window',window,'datastruct',datastruct)

p = inputParser;
p.addParamValue('trial',[],@isnumeric);
p.addParamValue('name','',@ischar);
p.addParamValue('window',[],@isnumeric);
p.addParamValue('datastruct',struct,@isstruct);
parse(p,varargin{:});

trial = p.Results.trial;
name = p.Results.name;
window = p.Results.window;
datastruct = p.Results.datastruct;

if ~isempty(name);
    [prot,d,fly,cell,trial,D] = extractRawIdentifiers(name);
    trial = str2num(trial);
    rawfiles = dir([D prot '_Raw*']);
end
if isempty(window) && ~isempty(name)
    window = [1,length(rawfiles)];
    
    if length(fieldnames(datastruct))==0 || length(datastruct) ~= length(rawfiles) %#ok<ISMT>
        dfile = [prot '_' d '_' fly '_' cell '.mat'];
        dataFileName = fullfile(D,dfile);
        
        dataFileExist = dir(dataFileName);
        if length(dataFileExist)>0
            datastruct = load(dataFileName);
            datastruct = datastruct.data;
        end
        if ~length(dataFileExist) || length(datastruct) ~= length(rawfiles)
            createDataFileFromRaw(dataFileName);
            datastruct = load(dataFileName);
        end
    end
end
if ~isempty(fieldnames(datastruct)) && isempty(window)
    window = [1,length(datastruct)];
end
    
% find like trials

for d = 1:length(datastruct)
    if datastruct(d).trial == trial
        compare = datastruct(d);
    end
end

likenums = [];
likeinds = [];
for d = 1:length(datastruct)
    if datastruct(d).trial < min(window) || datastruct(d).trial > max(window)
        continue
    end
    fn = fieldnames(compare);
    e = true;
    for f = 1:length(fn)
        if strcmp('trial',fn{f})
            continue
        end
        switch class(datastruct(d).(fn{f}))
            case 'double'
                if datastruct(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
            case 'char'
                if datastruct(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
            case 'cell'
                if ~isempty(setxor(compare.(fn{f}),datastruct(d).(fn{f})))
                    e = false;
                    break
                end
        end
    end
    if e
        likenums(end+1) = datastruct(d).trial;
        likeinds(end+1) = d;
    end
end

varargout = {likenums,likeinds};
function fig = layout(h,varargin)

if nargin>1
    name = varargin{1};
else
    name = 'Untitled';
end
ch = get(h(1),'children');
for c=  1:length(ch)
    xlimscell{c} = [Inf -Inf];
    ylimscell{c} = [Inf -Inf];
end
for f = h(:)'
    % assume all figures have the same subplots clear
    ch = get(f,'children');
    for c = 1:length(ch)
        xlims = xlimscell{c};
        xl = get(ch(c),'xlim');
        xlims = [min(xl(1),xlims(1)), max(xl(2),xlims(2))];
        xlimscell{c} = xlims;
        
        ylims = ylimscell{c};
        yl = get(ch(c),'ylim');
        ylims = [min(yl(1),ylims(1)), max(yl(2),ylims(2))];
        ylimscell{c} = ylims;
    end
    for c = 1:length(ch)
        set(ch(c),'xlim',xlimscell{c},'ylim',ylimscell{c});
        if f~=h(1);
            set(ch(c),'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
            set(ch(c),'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');
        end
    end
end

fig = figure;
set(fig,'Color','white','PaperPosition',[0.25,0.25 8, 10.5],...
    'name',name,...
    'fileName',regexprep(name,'[\s:-]','_'));
dim = size(h);
panels = h;
for y = 1:dim(1)
    for x = 1:dim(2)
        panels(y,x) = uipanel('parent',fig,'BorderType','none','BackgroundColor','white',...
            'position',[(x-1)*1/dim(2) (y-1)*1/dim(1) 1/dim(2) 1/dim(1)]);
    end
end
panels = flipud(panels);
for y = 1:dim(1)
    for x = 1:dim(2)
        copyobj(get(h(y,x),'children'),'parent',panels(y,x))
        close(h(y,x));
    end
end

hs = getappdata(fig,'PrintHeaderHeaderSpec');
if isempty(hs)
    hs = struct('dateformat','yyyy-mm-dd',...
        'string','test',...
        'fontname','Helvetica',...
        'fontsize',10,... % in points
        'fontweight','normal',...
        'fontangle','normal',...
        'margin',18); % in points
end

hs.string = name;
setappdata(fig,'PrintHeaderHeaderSpec',hs)

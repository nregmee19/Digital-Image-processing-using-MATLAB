function newhist(varargin);

global ax1
global ax2
global ax3
global ax4
global ax5
global ax6
global img1
global img2
global img3
global FIG
global FIG1
global FIG2
global FIG3
global fname

if nargin<1,
    action='initialize';
else
    action=varargin{1};
end;

if strcmp(action,'initialize'),
    FIG=figure( ...
        'Name','Histogram Equalization', ...
        'NumberTitle','off', ...
        'Units', 'pixels',...
        'Position',[100 100 848 702], ...
        'Visible','off');
    FIG1=0;
    FIG2=0;
    FIG3=0;
     colordef(FIG,'white')
     ax1=axes( 'Units','pixels',...
        'Position',[20 20 256 256]);
     ax2=axes( 'Units','pixels',...
        'Position',[296 20 256 256]);
     ax3=axes( 'Units','pixels',...
        'Position',[572 20 256 256]);
     ax4=axes( 'Units','pixels',...
        'Position',[20 296 256 256]);
     ax5=axes( 'Units','pixels',...
        'Position',[296 296 256 256]);
     ax6=axes( 'Units','pixels',...
        'Position',[572 296 256 256]);
    
%====================================
    % The Button frame
    uicontrol( ...
        'Style','frame', ...
        'Units','pixels', ...
        'Position',[10 562 828 110], ...
        'BackgroundColor',[0.50 0.50 0.50]);
%====================================
    % The LOAD IMAGE button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[20 622 256 40], ...
        'String','Load Image', ...
        'Callback','newhist(''load'')');
%====================================
    % The View Images button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[20 572 256 40], ...
        'String','View Full-size Images', ...
        'Callback','newhist(''view'')');
    
%====================================
    % The Save Histogram button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[296 572 256 40], ...
        'String','Save Histogram Image', ...
        'Callback','newhist(''savehist'')');
%====================================
    % The Save Adaptive button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[572 572 256 40], ...
        'String','Save Adaptive Histogram Image', ...
        'Callback','newhist(''saveadapt'')');
%====================================
    % The Quit button
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','pixels', ...
        'Position',[572 622 256 40], ...
        'String','Quit', ...
        'Callback','newhist(''quit'')');
    
    % Now uncover the figure
    set(FIG,'Visible','on');

elseif strcmp(action,'savehist'),
    save_image(img2);
elseif strcmp(action,'saveadapt'),
    save_image(img3);
elseif strcmp(action,'load'),
    if FIG1 ~= 0
        close(FIG1);
        FIG1=0;
    end
    if FIG2 ~=0
        close(FIG2);
        FIG2=0;
    end;
    if FIG3 ~=0
        close(FIG3);
        FIG3=0;
    end;
    axes(ax1);
    [img1,fname]=open_image;
    if isrgb(img1)
        img1=rgb2gray(img1);
    end
    imshow(img1);
    axes(ax2);
    img2=histeq(img1);
    imshow(img2);
    axes(ax3);
    img3=adapthisteq(img1);
    imshow(img3);
    axes(ax4);
    h=imhist(img1);
    bar(h),axis([1 256 0 max(h)*1.05]);
    axes(ax5);
    h=imhist(img2);
    bar(h),axis([1 256 0 max(h)*1.05]);
    axes(ax6);
    h=imhist(img3);
    bar(h),axis([1 256 0 max(h)*1.05]);
    
    figname=strcat('Histogram Equalization - ',fname);
    set(FIG,'Name',figname);
elseif strcmp(action,'view'),
    FIG1=figure('Name',strcat(fname,' - Original Image'), 'NumberTitle','off');
    imshow(img1);
    FIG2=figure('Name',strcat(fname,' - Histogram Equalized'), 'NumberTitle','off');
    imshow(img2);
    FIG3=figure('Name',strcat(fname,' - Adaptive Histogram Equalized'), 'NumberTitle','off');
    imshow(img3);
    figure(FIG);
elseif strcmp(action,'quit'),
    close all hidden;
end;

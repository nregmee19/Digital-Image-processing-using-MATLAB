%% Justo Lorenzo 
%%Project 2
%% EE4323 T TH 9:30AM

function project2
%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[644,-365,1280,606]);

% Construct the components.
h1 = uicontrol('Style','pushbutton',...
    'String','Open Image','Position',[950,405,228,51],...
    'Callback',@selectImagebutton_Callback);
h2 = uicontrol('Style','pushbutton',...
    'String','Save Image','Position',[950,322,228,51],...
    'Callback',@saveImagebutton_Callback);
h3 = uicontrol('Style','pushbutton',...
    'String','Preview','Position',[950,239,228,51],...
    'Callback',@previewImagebutton_Callback);
h4 = uicontrol('Style','pushbutton',...
    'String','Apply Changes','Position',[950,156,228,51],...
    'Callback',@applyChangesbutton_Callback);
h5 = uicontrol('Style', 'popup',...
    'String',{'Lowpass 3x3','Lowpass 5x5', 'Lowpass 7x7',...
    'Lowpass 9x9','Highpass','Highboost','Brightness control',...
    'Contrast control','Histogram equalization'},...
    'Position', [950 529 169 27],...
    'Callback', @filterChoice_Callback);
%hcontour = uicontrol('Style','pushbutton',...
%   'String','Contour','Position',[315,135,70,25],...
%  'Callback',@contourbutton_Callback);
%htext  = uicontrol('Style','text','String','Select Data',...
%   'Position',[325,90,60,15]);
%hpopup = uicontrol('Style','popupmenu',...
%   'String',{'Peaks','Membrane','Sinc'},...
%  'Position',[300,50,100,25],...
% 'Callback',@popup_menu_Callback);
ha1 = axes('Units','pixels','Position',[49,52,390,404]);
ha2 = axes('Units','pixels','Position',[480,52,390,404]);
%align([hsurf,hmesh,hcontour,htext,hpopup],'Center','None');

% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';
ha1.Units = 'normalized';
ha2.Units = 'normalized';
%hsurf.Units = 'normalized';
%hmesh.Units = 'normalized';
%hcontour.Units = 'normalized';
%htext.Units = 'normalized';
%hpopup.Units = 'normalized';

% Generate the data to plot.
filename1 = '';
I = [];
J = [];
current_data = 1; % default value

% Assign the a name to appear in the window title.
f.Name = 'Project #2 - NirajRegmee';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to
%  current_data because this function is nested at a lower level.
    function filterChoice_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        current_data = val;
    end

% Push button callbacks. Each callback plots current_data in the
% specified plot type.

    function selectImagebutton_Callback(source,eventdata)
        % Display surf plot of the currently selected data.
        [filename1,user_cancelled] = imgetfile; % get full filename
        if(user_cancelled)
            errordlg('User pressed Cancel','!! Error !!');
            return;
        end
        set(f, 'currentaxes', ha1);  %# for axes with handle axs on figure f
        I = imread(filename1); % Read image with the filename1
        imshow(I); % Display the selected image to axes1 figure
    end

    function saveImagebutton_Callback(source,eventdata)
        % Display mesh plot of the currently selected data.
        [filename,ext,user_canceled] = imputfile;
        imwrite(J,[filename,'.',ext]);
    end

    function previewImagebutton_Callback(source,eventdata)
        % Display surf plot of the currently selected data.
        set(f, 'currentaxes', ha2);  %# for axes with handle axs on figure f
        switch current_data
            case 1 % Lowpass 3 by 3
                h = (1/9)*ones(3,3);
                J = imfilter(I,h,'symmetric', 'conv');
            case 2 % Lowpass 5 by 5
                h = (1/25)*ones(5,5);
                J = imfilter(I,h,'symmetric', 'conv');
            case 3 % Lowpass 7 by 7
                h = (1/49)*ones(7,7);
                J = imfilter(I,h,'symmetric', 'conv');
            case 4 % Lowpass 9 by 9
                h = (1/81)*ones(9,9);
                J = imfilter(I,h,'symmetric', 'conv');
            case 5 % Highpass
                h = [0 0 0;0 1 0;0 0 0] - (1/9)*ones(3,3);
                J = imfilter(I,h,'symmetric', 'conv');
            case 6 % Highboost filter
                prompt = 'Enter the boost scaling coefficient:';
                dlg_title = 'Input';
                k = inputdlg(prompt,dlg_title);
                h = (1/9)*[-1 -1 -1;-1 9*str2double(k{1,1})-1 -1;-1 -1 -1];
                J = imfilter(I,h,'symmetric', 'conv');
            case 7 % Increase/Decrease brightness by a shift k
                prompt = 'Enter a value for the brighntess shift:';
                dlg_title = 'Input';
                k = inputdlg(prompt,dlg_title);
                J = I + str2double(k{1,1});
            case 8 % Increase/Decrease contrast by a scaling factor k
                prompt = 'Enter a value for the scaling factor:';
                dlg_title = 'Input';
                k = inputdlg(prompt,dlg_title);
                J = I*str2double(k{1,1});
            otherwise
                J = histeq(I);
        end
        imshow(J); % Display the selected image to axes1 figure
    end

    function applyChangesbutton_Callback(source,eventdata)
        % Display surf plot of the currently selected data.
        set(f, 'currentaxes', ha1);  %# for axes with handle axs on figure f
        I = J;
        imshow(I); % Display the selected image to axes1 figure
    end
end
%% Justo Lorenzo 
%%Project 3
%% EE4323 T TH 9:30AM

function project3

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
h6 = uicontrol('Style', 'text',...
    'String','Spatial-domain filters',...
    'Position', [950 560 172 14],'FontWeight','bold');
h7 = uicontrol('Style', 'popup',...
    'String',{'Lowpass','Highpass', 'Highboost',...
    'Bandpass','Bandstop','Homomorphic'},...
    'Position', [950 475 169 27],...
    'Callback', @filterChoice2_Callback);
h8 = uicontrol('Style', 'text',...
    'String','Frequency-domain filters',...
    'Position', [950 506 172 14],'FontWeight','bold');
h9 = uicontrol('Style', 'popup',...
    'String',{'Spatial','Frequency'},...
    'Position', [150 525 169 27],...
    'Callback', @filterDomain_Callback);
h10 = uicontrol('Style', 'text',...
    'String','Filter Domain',...
    'Position', [150 556 172 14],'FontWeight','bold');
h11 = uicontrol('Style', 'popup',...
    'String',{'Ideal','Gaussian','Butterworth'},...
    'Position', [550 525 169 27],...
    'Callback', @filterApproximation_Callback);
h12 = uicontrol('Style', 'text',...
    'String','Filter Approximation',...
    'Position', [559 556 172 14],'FontWeight','bold');


ha1 = axes('Units','pixels','Position',[49,52,390,404]);
ha2 = axes('Units','pixels','Position',[480,52,390,404]);


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
I = []; % Global variable to store the input image
J = []; % Global variable to store the output image
J1 = []; % Global variable in case of homomorphic filter
filtapp = []; % Global variable to store the filter's approximation
domain = []; % Global variable which indicates the domain
current_data = 1; % default value for spatial domain filter
current_data2 = 1; % default value for frequency domain filter


% Assign the a name to appear in the window title.
f.Name = 'Homework #3 - Justo Lorenzo';

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

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to
%  current_data because this function is nested at a lower level.
    function filterChoice2_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        current_data2 = val;
    end

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to
%  current_data because this function is nested at a lower level.
    function filterApproximation_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        filtapp = val;
    end

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to
%  current_data because this function is nested at a lower level.
    function filterDomain_Callback(source,eventdata)
        % Determine the selected data set.
        %str = get(source, 'String');
        val = get(source,'Value');
        domain = val;
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
        if(size(I,3) == 1) % Case where image is not rgb
            if(domain == 1)
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
            else % Case where domain is frequency
                Is = fft2(I); % Take the 2-D FT of the original image
                Is = fftshift(Is); % Shift Image Spectrum to the center
                [M,N] = size(I); % get dimensions of array I_original
                u=0:(M-1);
                v=0:(N-1);
                idx=find(u>M/2);
                u(idx)=u(idx)-M;
                idy=find(v>N/2);
                v(idy)=v(idy)-N;
                [V,U]=meshgrid(v,u);
                D = sqrt(U.^2 + V.^2); % Distances D(u,v)
                switch current_data2 % Different filter selection
                    case 1 % Case of lowpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal lowpass
                            H = double(D<=D0);
                        elseif(filtapp == 2) % Gaussial lowpass
                            H = exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth lowpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D./D0).^(2*n));
                        end
                    case 2 % Case of highpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                    case 3 % Case of higboost
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify high-boost factor:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        A = inputdlg(prompt1,dlg_title);
                        A = str2double(A{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                        H = (A-1) + H; % highboost filter H(u,v)
                    case 4 % Case of bandpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify filter''s width:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        W = inputdlg(prompt1,dlg_title);
                        W = str2double(W{1,1});
                        if(filtapp == 1) % Ideal bandpass
                            H = double((D>=(D0-(W/2))) & (D<=(D0+(W/2))));
                        elseif(filtapp == 2) % Gaussial bandpass
                            H = 1-exp(-((((D.^2)-(D0^2))./(D*W)).^2));
                        else % Butterworth bandpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(((D*W)./(D.^2-D0^2)).^(2*n)));
                        end
                        H = 1 - H; % Bandpass filter H(u,v)
                    case 5 % Case of bandstop
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify filter''s width:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        W = inputdlg(prompt1,dlg_title);
                        W = str2double(W{1,1});
                        if(filtapp == 1) % Ideal bandstop
                            H = double((D>=(D0-(W/2))) & (D<=(D0+(W/2))));
                        elseif(filtapp == 2) % Gaussial bandstop
                            H = 1-exp(-((((D.^2)-(D0^2))./(D*W)).^2));
                        else % Butterworth bandstop
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(((D*W)./(D.^2-D0^2)).^(2*n)));
                        end
                    otherwise
                        Is = im2double(I);
                        Is = log(1+Is);
                        IS = fft2(Is);
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                end
                H = fftshift(H);
                if(current_data2>=1 && current_data2<=5)
                    J = H.*Is; % Calculate the filtered image in the frequency domain
                    J = real(ifft2(ifftshift(J))); % Apply inverse 2-D Fourier transform
                else
                    J = real(ifft2(H.*IS));
                    J = exp(J) - 1;
                end
            end
        else
            I1 = I(:,:,1); % R component
            I2 = I(:,:,2); % G component
            I3 = I(:,:,3); % G component
            if(domain == 1)
                switch current_data
                    case 1 % Lowpass 3 by 3
                        h = (1/9)*ones(3,3);
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 2 % Lowpass 5 by 5
                        h = (1/25)*ones(5,5);
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 3 % Lowpass 7 by 7
                        h = (1/49)*ones(7,7);
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 4 % Lowpass 9 by 9
                        h = (1/81)*ones(9,9);
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 5 % Highpass
                        h = [0 0 0;0 1 0;0 0 0] - (1/9)*ones(3,3);
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 6 % Highboost filter
                        prompt = 'Enter the boost scaling coefficient:';
                        dlg_title = 'Input';
                        k = inputdlg(prompt,dlg_title);
                        h = (1/9)*[-1 -1 -1;-1 9*str2double(k{1,1})-1 -1;-1 -1 -1];
                        J1 = imfilter(I1,h,'symmetric', 'conv');
                        J2 = imfilter(I2,h,'symmetric', 'conv');
                        J3 = imfilter(I3,h,'symmetric', 'conv');
                    case 7 % Increase/Decrease brightness by a shift k
                        prompt = 'Enter a value for the brighntess shift:';
                        dlg_title = 'Input';
                        k = inputdlg(prompt,dlg_title);
                        J1 = I1 + str2double(k{1,1});
                        J2 = I2 + str2double(k{1,1});
                        J3 = I3 + str2double(k{1,1});
                    case 8 % Increase/Decrease contrast by a scaling factor k
                        prompt = 'Enter a value for the scaling factor:';
                        dlg_title = 'Input';
                        k = inputdlg(prompt,dlg_title);
                        J1 = I1*str2double(k{1,1});
                        J2 = I2*str2double(k{1,1});
                        J3 = I3*str2double(k{1,1});
                    otherwise
                        J1 = histeq(I1);
                        J2 = histeq(I2);
                        J3 = histeq(I3);
                end
            else
                Is1 = fft2(I1); % Take the 2-D FT of the original image
                Is1 = fftshift(Is1); % Shift Image Spectrum to the center
                Is2 = fft2(I2); % Take the 2-D FT of the original image
                Is2 = fftshift(Is2); % Shift Image Spectrum to the center
                Is3 = fft2(I3); % Take the 2-D FT of the original image
                Is3 = fftshift(Is3); % Shift Image Spectrum to the center
                [M,N,~] = size(I); % get dimensions of array I_original
                u=0:(M-1);
                v=0:(N-1);
                idx=find(u>M/2);
                u(idx)=u(idx)-M;
                idy=find(v>N/2);
                v(idy)=v(idy)-N;
                [V,U]=meshgrid(v,u);
                D = sqrt(U.^2 + V.^2); % Distances D(u,v)
                switch current_data2 % Different filter selection
                    case 1 % Case of lowpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal lowpass
                            H = double(D<=D0);
                        elseif(filtapp == 2) % Gaussial lowpass
                            H = exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth lowpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D./D0).^(2*n));
                        end
                    case 2 % Case of highpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                    case 3 % Case of higboost
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify high-boost factor:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        A = inputdlg(prompt1,dlg_title);
                        A = str2double(A{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                        H = (A-1) + H; % highboost filter H(u,v)
                    case 4 % Case of bandpass
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify filter''s width:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        W = inputdlg(prompt1,dlg_title);
                        W = str2double(W{1,1});
                        if(filtapp == 1) % Ideal bandpass
                            H = double((D>=(D0-(W/2))) & (D<=(D0+(W/2))));
                        elseif(filtapp == 2) % Gaussial bandpass
                            H = 1-exp(-((((D.^2)-(D0^2))./(D*W)).^2));
                        else % Butterworth bandpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(((D*W)./(D.^2-D0^2)).^(2*n)));
                        end
                        H = 1 - H; % Bandpass filter H(u,v)
                    case 5 % Case of bandstop
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        prompt1 = 'Specify filter''s width:';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        W = inputdlg(prompt1,dlg_title);
                        W = str2double(W{1,1});
                        if(filtapp == 1) % Ideal bandstop
                            H = double((D>=(D0-(W/2))) & (D<=(D0+(W/2))));
                        elseif(filtapp == 2) % Gaussial bandstop
                            H = 1-exp(-((((D.^2)-(D0^2))./(D*W)).^2));
                        else % Butterworth bandstop
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(((D*W)./(D.^2-D0^2)).^(2*n)));
                        end
                    otherwise
                        Is1 = im2double(I1);
                        Is2 = im2double(I2);
                        Is3 = im2double(I3);
                        Is1 = log(1+Is1);
                        Is2 = log(1+Is2);
                        Is3 = log(1+Is3);
                        Is1 = fft2(Is1);
                        Is2 = fft2(Is2);
                        Is3 = fft2(Is3);
                        prompt = 'Specify cutoff frequency:';
                        dlg_title = 'Input';
                        D0 = inputdlg(prompt,dlg_title);
                        D0 = str2double(D0{1,1});
                        if(filtapp == 1) % Ideal highpass
                            H = double(D>D0);
                        elseif(filtapp == 2) % Gaussial highpass
                            H = 1-exp(-(D.^2)./(2*(D0^2)));
                        else % Butterworth highpass
                            prompt = 'Specify filter order:';
                            dlg_title = 'Input';
                            n = inputdlg(prompt,dlg_title);
                            n = str2double(n{1,1});
                            H = 1./(1+(D0./D).^(2*n));
                        end
                end
                H = fftshift(H);
                if(current_data2>=1 && current_data2<=5)
                    J1 = H.*Is1; % Calculate the filtered image in the frequency domain
                    J2 = H.*Is2; % Calculate the filtered image in the frequency domain
                    J3 = H.*Is3; % Calculate the filtered image in the frequency domain
                    J1 = real(ifft2(ifftshift(J1))); % Apply inverse 2-D Fourier transform
                    J2 = real(ifft2(ifftshift(J2))); % Apply inverse 2-D Fourier transform
                    J3 = real(ifft2(ifftshift(J3))); % Apply inverse 2-D Fourier transform
                else
                    J1 = real(ifft2(H.*Is1));
                    J2 = real(ifft2(H.*Is2));
                    J3 = real(ifft2(H.*Is3));
                    J1 = exp(J1) - 1;
                    J2 = exp(J2) - 1;
                    J3 = exp(J3) - 1;
                end
            end
            J = cat(3,J1,J2,J3);
        end
        J = mat2gray(J); % convert back to grayscale
        imshow(J); % Display the selected image to axes1 figure
    end

    function applyChangesbutton_Callback(source,eventdata)
        % Display surf plot of the currently selected data.
        set(f, 'currentaxes', ha1);  %# for axes with handle axs on figure f
        I = J;
        imshow(I); % Display the selected image to axes1 figure
    end
end
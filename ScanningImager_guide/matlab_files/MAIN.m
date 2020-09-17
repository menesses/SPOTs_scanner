% SCANNINGIMAGER.M
% AUTHOR: MARK MENESSES
% DATE: 1 SEPTEMBER 2020
% Tested with R2019b
%
% Requirements:
% - Image Acquisition Toolbox
% - GenICam Support Package
%        (https://www.mathworks.com/hardware-support/gentl.html)
% 
% For use with BlackBox Controller (or maybe any controller running GRBL?)
% and Basler acA3800-14uc camera.
% 
% Info on GRBL: https://github.com/gnea/grbl/wiki/Grbl-v1.1-Configuration
%

%% Start fresh
clc
clear all
close all

%% USER INPUTS
n_rows = 10;
n_cols = 10;

registration_points = [1, 1;...
                       1, 10;...
                       10, 10];

feedrate = 1000;

%% CAMERA OPTIONS
% Connect to device (valid formats: 'BayerBG8', 'BayerBG12', 'Mono8')
vid = videoinput('gentl',1,'BayerBG8');

% Common properties to tweak. See all available properties using the
% command "get(getselectedsource(vid))"
set(vid.Source,...
    'BalanceWhiteAuto', 'Off',...
    'DecimationHorizontal', 1,...
    'DecimationVertical', 1,...
    'ExposureAuto', 'Once',...
    'Gain', 0,...
    'GainAuto', 'Off',...
    'ShutterMode', 'Rolling');
%     'ExposureTime', 35000,...

% Only capture one image at a time
set(vid,'FramesPerTrigger',1);


%% Connect to controller

% Define serial port and establish settings
ser = serial('COM5');
set(ser,'BaudRate',115200);
set(ser,'Parity','none');
set(ser,'DataBits',8);
set(ser,'StopBit',1);

% Open port and initialize
fopen(ser);
fprintf(ser,'\r\n\r\n');
pause(2)
getResponse(ser); % "error:9" is expected due to use of soft limits

% Need to home to unlock
fprintf(ser,'$H\n');
ismoving = true;
while ismoving
    ismoving = ~isStopped(ser);
    disp('Homing...')
    pause(0.1)
end
disp('Homed!')

% Set zero at homed position
fprintf(ser,'G10P1L20X0Y0Z0\n');
getResponse(ser);

%%

% Using GUI applet to jog and capture registration points
% Passing in video and serial port
disp(['Expecting points: (', num2str(registration_points(1,:)),'), (',...
    num2str(registration_points(2,:)),'), (',...
    num2str(registration_points(3,:)),')'])
realPoints = jogapplet(vid,ser);

% Return to absolute programming
fprintf(ser,'G90\n');

% Reset some camera values
set(vid.Source,'DecimationHorizontal',1)
set(vid.Source,'DecimationVertical',1)

%% Beginning loop
check4Alarm(ser)

% Generate spot map and transform using registration points
idealPoints = registration_points;
tform_matrix = fitgeotrans(idealPoints,realPoints,'affine');
[idealx,idealy] = meshgrid([1:n_cols],[1:n_rows]);
[machinex,machiney] = transformPointsForward(tform_matrix,idealx,idealy);

%% Looping through all coordinates
for i=1:numel(idealx)
    xloc = machinex(i);
    yloc = machiney(i);
    
    % Move to position
    movestage(ser,xloc,yloc,feedrate)
    waituntilstopped(ser)
    check4Alarm(ser)
    
    % Check current position
    checkposition = false;
    n=0;
    while checkposition == false
        [~,~,here] = getWCoMPos(ser);
        if and(round(abs(here(1)-xloc),3)<0.045,round(abs(here(2)-yloc),3)<0.045)
            % First check if we think we're within 45um of our point
            checkposition = true;
        elseif n==1
            % If not within tolerance at first try, just reissue the gcode
            % command.
            movestage(ser,xloc,yloc,feedrate)
            waituntilstopped(ser)
        elseif n > 5
            % Raise error after 5 attempts if unsuccessful
            error("Can't get to position")
        else
            % If off after reissuing original command, try moving away a
            % litte, then reissue command
            movestage(ser,xloc+1+rand*3,yloc+1+rand*3,100)
            waituntilstopped(ser)
            movestage(ser,xloc,yloc,feedrate)
            waituntilstopped(ser)
        end
    end
    
    % Throw out any existing images
    if vid.FramesAvailable>0
        data = getdata(vid);
        data = [];
    end
    
    % Take image
    imgname = [num2str(idealx(i)),'_',num2str(idealy(i)),'-img',...
        num2str(i),'.png'];
    start(vid)
    % Wait up to 30 seconds for successful capture
    startwatch = now;
    stopwatch = 0;
    while and(vid.FramesAvailable==0,stopwatch<30)
        pause(0.1)
        stopwatch = (now - startwatch)*24*60*60;
    end
    
    % Save image (with CreationTime metadata) if successful.
    if vid.FramesAvailable > 0
        [img,~,frameinfo] = getdata(vid,1);
        imwrite(img,imgname,'CreationTime',datestr(frameinfo.AbsTime));
    elseif vid.FramesAvailable == 0
        disp('Frame not captured!')
    end
    
end

% Write CSV file with image number and coordinates
A=zeros(numel(idealx),3);
for i = 1:numel(idealx)
    A(i,1)=i;
    A(i,2)=machinex(i);
    A(i,3)=machiney(i);
end
T = array2table(A,'VariableNames',{'ImageNo.','X_pos','Y_pos'});
tablename = [strrep(strrep(datestr(datetime),' ','_'),':',''),...
    '_img_positions.csv'];
writetable(T,tablename,'Delimiter',',');

fclose(ser);
delete(vid);
delete(ser);
clear vid ser

% Data collected from smartphone accelerometer
%Train Data%
clear;

load('raw_data_combined.mat','combined_train_tt');
load('time_combined.mat','train_time');

a = table2array(combined_train_tt);
t = train_time;

wl = 200; % window length
wi = 20;  % window increment

win = floor((size(a,1)-wl)/wi); % Number of windows
X_axis = zeros(win,3);       % Initialize feature matrices
Y_axis = zeros(win,3);
Z_axis = zeros(win,3);

% Extract features for each activity
for i = 1:3
    if i == 1
        start_idx = 1;
        end_idx = 421;
    elseif i == 2
        start_idx = 422;
        end_idx = 846;
    else
        start_idx = 847;
        end_idx = 1261;
    end
    
    st = start_idx;
    en = start_idx + wl - 1;
    
    for j = 1:win
        if en <= end_idx % check if end index is within bounds
            X_axis(j,i) = mean(a(st:en,1)); % X axis
            Y_axis(j,i) = mean(a(st:en,2)); % Y axis
            Z_axis(j,i) = mean(a(st:en,3)); % Z axis

            % Calculate RMS values
            X_axis_rms(j,i) = rms(a(st:en,1)); % X axis
            Y_axis_rms(j,i) = rms(a(st:en,2)); % Y axis
            Z_axis_rms(j,i) = rms(a(st:en,3)); % Z axis
            
            % Calculate standard deviation values
            X_axis_std(j,i) = std(a(st:en,1)); % X axis
            Y_axis_std(j,i) = std(a(st:en,2)); % Y axis
            Z_axis_std(j,i) = std(a(st:en,3)); % Z axis
            
            st = st + wi;
            en = en + wi;
        else % if end index is out of bounds, break loop
            break;
        end
    end
end
x1 = X_axis_rms(1:j-1,1);
x2 = X_axis_rms(1:j-1,2);
x3 = X_axis_rms(1:j-1,3);
X_axis_rms = [x1;x2;x3];

y1 = Y_axis_rms(1:j-1,1);
y2 = Y_axis_rms(1:j-1,2);
y3 = Y_axis_rms(1:j-1,3);
Y_axis_rms = [y1;y2;y3];

z1 = Z_axis_rms(1:j-1,1);
z2 = Z_axis_rms(1:j-1,2);
z3 = Z_axis_rms(1:j-1,3);
Z_axis_rms = [z1;z2;z3];

x1 = X_axis_std(1:j-1,1);
x2 = X_axis_std(1:j-1,2);
x3 = X_axis_std(1:j-1,3);
X_axis_std = [x1;x2;x3];

y1 = Y_axis_std(1:j-1,1);
y2 = Y_axis_std(1:j-1,2);
y3 = Y_axis_std(1:j-1,3);
Y_axis_std = [y1;y2;y3];

z1 = Z_axis_std(1:j-1,1);
z2 = Z_axis_std(1:j-1,2);
z3 = Z_axis_std(1:j-1,3);
Z_axis_std = [z1;z2;z3];

x1 = X_axis(1:j-1,1);
x2 = X_axis(1:j-1,2);
x3 = X_axis(1:j-1,3);
X_axis = [x1;x2;x3];

y1 = Y_axis(1:j-1,1);
y2 = Y_axis(1:j-1,2);
y3 = Y_axis(1:j-1,3);
Y_axis = [y1;y2;y3];

z1 = Z_axis(1:j-1,1);
z2 = Z_axis(1:j-1,2);
z3 = Z_axis(1:j-1,3);
Z_axis = [z1;z2;z3];


% Concatenate the feature matrices
features = [X_axis Y_axis Z_axis;X_axis_rms Y_axis_rms Z_axis_rms;X_axis_std Y_axis_std Z_axis_std];

% Generate labels
labels = [ones(1,j-1) 2*ones(1,j-1) 3*ones(1,j-1) ones(1,j-1) 2*ones(1,j-1) 3*ones(1,j-1) ones(1,j-1) 2*ones(1,j-1) 3*ones(1,j-1)]';

% Create a table for importing into Classification Learner App
CL_data = table(features, labels);

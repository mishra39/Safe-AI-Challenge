%%This function takes a subset of the provided data and the lane_num for
%%evaluation and outputs the probabilities for each of the risky cases separately

function [prob_1,prob_2, prob_tot] = prob_calc(data_sec, lane_num)
prob_1 = 0;
prob_2 = 0;
prob_tot = 0;
laneID = data_sec(:,14);
lane_data = data_sec((laneID==lane_num), :); % Extracting Data for vehicles in lane 1

%% Extracting relevant parameters
global_x = lane_data(:,7);
vel = lane_data(:,12);
veh_id = lane_data(:,1);
v_len = lane_data(:,9);
space_gap = lane_data(:,23);
time_gap = lane_data(:,24);

%% Filtering signal noise using moving-average computation
a = 1; %coefficient
b(1,1:800) = 1/800; %coefficients
time_gap = filter(b,a,time_gap);
vel = filter(b,a,vel);
v_len = filter(b,a,v_len);
space_gap = filter(b,a,space_gap);
vel_noise = lane_data(:,12); %Noisy Data

%% Distance between vehicles and risky criteria evaluation
%% Lane 1
vehicle_gap = space_gap - v_len;
vehicle_gap_4 = lane_data(vel>0,:); %Separating vehicles 
vehicle_gap_4 = vehicle_gap_4(vehicle_gap < 4);
vehicle_gap_4 = vehicle_gap_4(vehicle_gap_4 > 0);
fav_4 = numel(vehicle_gap_4);
prob_1 = (fav_4 *100)/ numel(vehicle_gap); % Dividing favorable occurrences with total elements
lane_num = linspace(1,6,6); % X label for probability plots

%% Separating and applying condition for velocity > 2mph
lane_data_2mph = lane_data(vel > 2,:); % Vehicles with speed greater than 2mph
lane_data_2mph = lane_data(vehicle_gap > 0,:); 
lane_data_2mph = lane_data(vehicle_gap < 15,:); % Vehicles with headway less than 15ft
veh_id_2mph = lane_data(:,1);%Vehicles with headway less than 15ft
fav_2mph = numel(lane_data_2mph(:,1));
prob_2 = (fav_2mph*100)/ numel(vehicle_gap);

%% Combining Probabilities
prob_tot = (prob_1*prob_2)/100;
%% Poisson's Model Implementation
%Condition 2
% lane_time = (max(lane_data(:,4))-min(lane_1_data(:,4)))/1000; %Elapsed time in Lane 1
% tot_veh = p/(lane_1_time/3600); % Vehicles per hour in 3.1049e+05 hours of data acquisition
% gap_time = 5; % Duration of gap for which probability is to be calculated
% lambda = (tot_veh*gap_time)/3600;
% prob_2 = exp(-lambda);



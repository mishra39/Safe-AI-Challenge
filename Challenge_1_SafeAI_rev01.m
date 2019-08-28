%*****************************************************************************************%
% % % % % % % % % % % % % % % %Created By: Akshit Mishra% % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %Project: Challenge 1-NSF Safe AI% % % % % % % % % % % 
%******************************************************************************************%

%% Import all data from csv file
clc;
clear all;
dataLabel = false;
filename = 'all_data.mat';

% Only use readmatrix if necessasry
switch dataLabel
    case true
        data = readmatrix('Next_Generation_Simulation__NGSIM__Vehicle_Trajectories_and_Supporting_Data.csv');
        save(filename,'-v7.3');
        
    case false
       load(filename);
end

%% Extracting relavant data for processing
extract_meas = 9000;
data_sub = data(1:extract_meas,:);
prob_1 = zeros(1,3);
prob_2 = zeros(1,3);
prob_comb = zeros(1,3);;
lane_num = [1,2,11];
%% Calling Probability Function
for lane = 1:3
    lane_num2 = lane_num(lane);
    [prob_cond_1, prob_cond_2, prob_to] = prob_calc(data_sub,lane_num2);
    prob_1(lane) = prob_cond_1;
    prob_2(lane) = prob_cond_2;
    prob_comb(lane) = prob_to;
end

%% Comparison between filtered and noisy data
figure(1)
clf;
subplot(2,1,1)
plot(vel_noise)
ylabel('Velocity(Unfiltered) in mph')
title('Comparison of Noisy and Filtered Signals for velocity')

subplot(2,1,2)
plot(vel)
ylabel('Velocity(Filtered) in mph')

%% Plots for probabilities
figure(2)
clf;

bar(prob_1)
xticklabels({'Lane 1','Lane 2','Lane 11'});
title('% Occurrence of condition 1 for various lanes')
xlabel('Lane Number');
ylabel('Probability (%) of occurrence for condition 1')

figure(3)
clf;

bar(prob_2)
xticklabels({'Lane 1','Lane 2','Lane 11'});
title('% Occurrence of condition 2 with traditional approach')
xlabel('Lane Number');
ylabel('Probability (%) of occurrence for condition 2')

figure(4)
clf;

bar(prob_comb)
xticklabels({'Lane 1','Lane 2','Lane 11'});
title('% Occurrence of conditions 1 and 2 with traditional approach')
xlabel('Lane Number');
ylabel('Probability (%) of occurrence for both conditions')

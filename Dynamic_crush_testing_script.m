% Dynamic Crush Testing Data Analysiser and Plotter


% Import and sort experimental data

% Load raw data from csv file
load A1data.csv
load A2data.csv
load B1data.csv
load B2data.csv
load B3data.csv

% Save each dataset to a matrix
A1 = A1data;
A2 = A2data;
B1 = B1data;
B2 = B2data;
B3 = B3data;

% Sample code to determine number of rows and columns
[row_A1, col_A1] = size(A1);
[row_A2, col_A2] = size(A2);
[row_B1, col_B1] = size(B1);
[row_B2, col_B2] = size(B2);
[row_B3, col_B3] = size(B3);

% Group data sets by specimen
A = {A1, A2};
B = {B1, B2, B3};
All_data = {A, B};


% Create cell arrays for each data type

% Raw data rows (sample number, displacement(mm), load(kN))


% Sample number is not  desired, create time data cell array from sample
% number data
% Convert sample number to time (sample number * sampling frequency)
freq = 100000; %sampling frequency = 100kHz
Time_data = {{[] []} {[] [] []}};
for ii=1:2
    if ii == 1
        for jj=1:2
            Time_data{ii}{jj} = All_data{ii}{jj}(1:size(All_data{ii}{jj},1),1);
            Time_data{ii}{jj} = Time_data{ii}{jj} ./ freq;
        end
    else
        for jj=1:3
            Time_data{ii}{jj} = All_data{ii}{jj};
            Time_data{ii}{jj} = Time_data{ii}{jj} ./ freq;
        end
    end
end

% Create displacement data cell array
% Raw data has initial displacement /= 0, set the initial displacement to 0
Disp_data = {{[] []} {[] [] []}};
for ii=1:2
    if ii == 1
        for jj=1:2
            Initial_displacement = All_data{ii}{jj}(1,2);
            Disp_data{ii}{jj} = All_data{ii}{jj}(1:size(All_data{ii}{jj},1),2);
            Disp_data{ii}{jj} = Disp_data{ii}{jj} - Initial_displacement;
        end
    else
        for jj=1:3
            Initial_displacement = All_data{ii}{jj}(1,2);
            Disp_data{ii}{jj} = All_data{ii}{jj}(1:size(All_data{ii}{jj},1),2);
            Disp_data{ii}{jj} = Disp_data{ii}{jj} - Initial_displacement;
        end
    end
end


% Displacement data has large amount of noise in readings. A moving mean
% will be used to smooth the readings, with a window size of 250 readings.
Smoothed_disp_data = {{[] []} {[] [] []}};
for ii=1:2
    if ii==1
        for jj=1:2
            Smoothed_disp_data{ii}{jj} = movmean(Disp_data{ii}{jj}, 500);
        end
    else
        for jj=1:3
            Smoothed_disp_data{ii}{jj} = movmean(Disp_data{ii}{jj}, 500);
        end
    end
end


% Create load data cell array
Load_data = {{[] []} {[] [] []}};
for ii=1:2
    if ii == 1
        for jj=1:2
            Load_data{ii}{jj} = All_data{ii}{jj}(1:size(All_data{ii}{jj},1),3);
        end
    else
        for jj=1:3
            Load_data{ii}{jj} = All_data{ii}{jj}(1:size(All_data{ii}{jj},1),3);
        end
    end
end



% Data Plotting

% Plot loading history

% Separate plots for each specimen type
for ii=1:2
    if ii == 1
        for jj=1:2
            figure(jj)
            clf
            plot(Time_data{ii}{jj}, Load_data{ii}{jj}, 'b');
            grid on
            xlabel('Time (s)');
            ylabel('Load (kN)');
            title(['Dynamic Crush Testing - Loading history - Specimen A - Experiment ' num2str(jj)])
            hgexport(gcf, ['loadinghistory-SpecimenA-Experiment' num2str(jj) '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        end
        figure(3)
        clf
        plot(Time_data{ii}{1}, Load_data{ii}{1}, 'b', Time_data{ii}{2}, Load_data{ii}{2}, 'g');
        grid on
        xlabel('Time (s)');
        ylabel('Load (kN)');
        title('Dynamic Crush Testing - Loading history - Specimen A')
        legend('Experiment 1', 'Location', 'SouthEast')
        hgexport(gcf, 'loadinghistory-SpecimenA.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
    else
        for jj=1:3
            figure(3+jj)
            clf
            plot(Time_data{ii}{jj}, Load_data{ii}{jj}, 'b');
            grid on
            xlabel('Time (s)');
            ylabel('Load (kN)');
            title(['Dynamic Crush Testing - Loading history - Specimen B - Experiment ' num2str(jj)])
            hgexport(gcf, ['loadinghistory-SpecimenB-Experiment' num2str(jj) '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        end
        figure(7)
        clf
        plot(Time_data{ii}{1}, Load_data{ii}{1}, 'b', Time_data{ii}{2}, Load_data{ii}{2}, 'g', Time_data{ii}{3}, Load_data{ii}{3}, 'c');
        grid on
        xlabel('Time (s)');
        ylabel('Load(kN)');
        title('Dynamic Crush Testing - Loading history - Specimen B')
        legend('Experiment 1' , 'Experiment 2', 'Experiment3', 'Location', 'SouthEast')
        hgexport(gcf, 'loadinghistory-SpecimenB.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
        
    end
end

% Combined plot
figure(8)
clf
hold on
grid on
xlabel('Time (s)');
ylabel('Load (kN)');
title('Dynamic Crush Testing - Loading history - All experiments')
plot(Time_data{1}{1}, Load_data{1}{1}, 'b', Time_data{1}{2}, Load_data{1}{2}, 'g');
plot(Time_data{2}{1}, Load_data{2}{1}, 'r', Time_data{2}{2}, Load_data{2}{2}, 'c', Time_data{2}{3}, Load_data{2}{3}, 'm');
legend('Specimen A - Experiment 1' , 'Specimen A - Experiment 2', 'Specimen B - Experiment 1', 'Specimen B - Experiment 2' , 'Specimen B - Experiment 3', 'Location', 'SouthEast')
hgexport(gcf, 'loadinghistoryplotalldata.jpg', hgexport('factorystyle'), 'Format', 'jpeg');

% Plot load vs displacement

% Separate plots for each specimen type
for ii=1:2
    if ii == 1
        for jj=1:2
            figure(8+jj)
            clf
            plot(Smoothed_disp_data{ii}{jj}, Load_data{ii}{jj}, 'b');
            grid on
            xlabel('Displacement (mm)');
            ylabel('Load (kN)');
            title(['Dynamic Crush Testing - Load vs Displacement - Specimen A - Experiment ' num2str(jj)])
            hgexport(gcf, ['loaddispplot-SpecimenA-Experiment' num2str(jj) '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        end
        figure(11)
        clf
        plot(Smoothed_disp_data{ii}{1}, Load_data{ii}{1}, 'b', Smoothed_disp_data{ii}{2}, Load_data{ii}{2}, 'g');
        grid on
        xlabel('Displacement (mm)');
        ylabel('Load (kN)');
        title('Dynamic Crush Testing - Load vs Displacement - Specimen A')
        legend('Experiment 1', 'Experiment 2', 'Location', 'SouthEast')
        hgexport(gcf, 'loaddispplot-SpecimenA.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
        
    else
        for jj=1:3
            figure(11+jj)
            clf
            plot(Smoothed_disp_data{ii}{jj}, Load_data{ii}{jj}, 'b');
            grid on
            xlabel('Displacement (mm)');
            ylabel('Load (kN)');
            title(['Dynamic Crush Testing - Load vs Displacement - Specimen B - Experiment ' num2str(jj)])
            hgexport(gcf, ['loaddispplot-SpecimenB-Experiment' num2str(jj) '.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
        end
        figure(15)
        clf
        plot(Smoothed_disp_data{ii}{1}, Load_data{ii}{1}, 'b', Smoothed_disp_data{ii}{2}, Load_data{ii}{2}, 'g', Smoothed_disp_data{ii}{3}, Load_data{ii}{3}, 'c');
        grid on
        xlabel('Displacement (mm)');
        ylabel('Load(kN)');
        title('Dynamic Crush Testing - Load vs Displacement - Specimen B')
        legend('Experiment 1' , 'Experiment 2', 'Experiment3', 'Location', 'SouthEast')
        hgexport(gcf, 'loaddispplot-SpecimenB.jpg', hgexport('factorystyle'), 'Format', 'jpeg');
        
    end
end

% Combined plot
figure(16)
clf
hold on
grid on
xlabel('Displacement (mm)');
ylabel('Load (kN)');
title('Dynamic Crush Testing - Load vs Displacement - All experiments')
plot(Smoothed_disp_data{1}{1}, Load_data{1}{1}, 'b', Smoothed_disp_data{1}{2}, Load_data{1}{2}, 'g');
plot(Smoothed_disp_data{2}{1}, Load_data{2}{1}, 'r', Smoothed_disp_data{2}{2}, Load_data{2}{2}, 'k', Smoothed_disp_data{2}{3}, Load_data{2}{3}, 'y');
legend('Specimen A - Experiment 1' , 'Specimen A - Experiment 2', 'Specimen B - Experiment 1', 'Specimen B - Experiment 2' , 'Specimen B - Experiment 3', 'Location', 'SouthEast')
hgexport(gcf, 'loaddispplotalldata.jpg', hgexport('factorystyle'), 'Format', 'jpeg');



% Data Analysis


% Calculate Total Energy Absorbed for each experiment
% Use trapezoid rule to find the area under the load vs displacement curve
% as curve is plotted from discrete data. Trapezoid rule rather than 
% Simpson's rule because displacement values are not evenly distributed.
% Define Total Energy Absorbed cell array
% Load (kN) * Displacement (mm) = Energy (J)
Total_energy_absorbed = {{[] []} {[] [] []}};
% Calculate for each specimen type
for ii=1:2
    if ii == 1
        % Specimen A only has data from two experiment 
        for jj=1:2
            x = Disp_data{ii}{jj};
            y = Load_data{ii}{jj};
            Total_energy_absorbed{ii}{jj} = trapz(x,y);
        end
    else
        % Specimen B has data from three experiments
        for jj=1:3
            x = Disp_data{ii}{jj};
            y = Load_data{ii}{jj};
            Total_energy_absorbed{ii}{jj} = trapz(x,y);
        end
    end
end


% Average Energy Absorption of Each Specimen
Average_energy_absorbed = {[] []};
for ii=1:2
    if ii==1
        Average_energy_absorbed{ii} = (Total_energy_absorbed{ii}{1} + Total_energy_absorbed{ii}{2})/2;
    else
        Average_energy_absorbed{ii} = (Total_energy_absorbed{ii}{1} + Total_energy_absorbed{ii}{2} + Total_energy_absorbed{ii}{3})/3;
    end
end


% Maximum and mean load per experiment (excluding loading once specimen has been
% fully crushed)
Max_load = {{[] []} {[] [] []}};
Mean_load = {{[] []} {[] [] []}};
% Experiment 1 - Max load across experiment
Max_load{1}{1} = max(Load_data{1}{1});
% Experiment 2 - Max load across experiment
Max_load{1}{2} = max(Load_data{1}{2});
% Experiment 3 - Max load in first 0.12s
Max_load{2}{1} = max(Load_data{2}{1}(1:12000));
% Experiment 4 - Max load in first 0.20s
Max_load{2}{2} = max(Load_data{2}{2}(1:20000));
% Experiment 5 - Max load across experiment
Max_load{2}{3} = max(Load_data{2}{3});
% Experiment 1 - Mean load across experiment
Mean_load{1}{1} = mean(Load_data{1}{1});
% Experiment 2 - Mean load across experiment
Mean_load{1}{2} = mean(Load_data{1}{2});
% Experiment 3 - Mean load in first 0.12s
Mean_load{2}{1} = mean(Load_data{2}{1}(1:12000));
% Experiment 4 - Mean load in first 0.20s
Mean_load{2}{2} = mean(Load_data{2}{2}(1:20000));
% Experiment 5 - Mean load across experiment
Mean_load{2}{3} = mean(Load_data{2}{3});


% Average Max and Mean Load of Each Specimen
Average_max_load = {[] []};
Average_mean_load = {[] []};
for ii=1:2
    if ii==1
        Average_max_load{ii} = (Max_load{ii}{1} + Max_load{ii}{2})/2;
        Average_mean_load{ii} = (Mean_load{ii}{1} + Mean_load{ii}{2})/2;
    else
        Average_max_load{ii} = (Max_load{ii}{1} + Max_load{ii}{2} + Max_load{ii}{3})/3;
        Average_mean_load{ii} = (Mean_load{ii}{1} + Mean_load{ii}{2} + Mean_load{ii}{3})/3;
    end
end



% Calculate Energy Efficiency
% Energy efficiency is ratio of energy absorbed to theoretical max energy
% absorption, i.e. max force * specimen stroke  (kN * mm = J)
Energy_efficiency = {{[] []} {[] [] []}};
% Calculate for each specimen type
for ii=1:2
    % All specimens have same length (100mm)
    if ii == 1
        % Specimen A only has data from two experiment 
        for jj=1:2
            Energy_efficiency{ii}{jj} = Total_energy_absorbed{ii}{jj} / (Max_load{ii}{jj} * 100);
        end
    else
        % Calculate for each experiment of a tube specimen type
        for jj=1:3
            Energy_efficiency{ii}{jj} = Total_energy_absorbed{ii}{jj} / (Max_load{ii}{jj} * 100);
        end
    end
end


% Calculate stroke efficiency for each experiment
% Stroke efficiency is ratio of crushed length to original length
Stroke_efficiency = {{[] []} {[] [] []}};
for ii=1:2
    % All tube specimens have same length (100mm), disp_data in mm
    if ii == 1
        % Specimen A only has data from one experiment 
        for jj=1:2
            Stroke_efficiency{ii}{jj} = max(Disp_data{ii}{jj}) / 100;
        end
    else
        % Calculate for each experiment of a tube specimen type
        for jj=1:3
            Stroke_efficiency{ii}{jj} = max(Disp_data{ii}{jj}) / 100;
        end
    end
end


% Calculate crush force efficiency for each experiment
% Crush force efficiency is ratio of mean force to max force
Crush_force_efficiency = {{[] []} {[] [] []}};
for ii=1:2
	if ii == 1
        for jj=1:2
            Crush_force_efficiency{ii}{jj} = Mean_load{ii}{jj}/Max_load{ii}{jj};
        end
	else
       for jj=1:3
           Crush_force_efficiency{ii}{jj} = Mean_load{ii}{jj}/Max_load{ii}{jj};
       end
   end
end

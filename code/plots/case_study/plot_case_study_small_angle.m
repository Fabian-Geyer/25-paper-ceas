%% Run this file from the correct folder


%% Common settings
fontName = 'Times';
fontSizeLabel = 10;
fontSizeLegend = 10;
fontSizeTicks = 10;
lineWidth = 1.2;
axesLineWidth = 1;

%% Colors
blue = [0 0.4470 0.7410];
red = [0.8500 0.3250 0.0980];
yellow = [0.9290 0.6940 0.1250];

%% 15 degree pitch
experimentName = 'case_study_small_angle';
[thisFolder, ~] = fileparts(mfilename("fullpath"));
% experiment_folder = "SoarStabilityAnalysis-27-Dec-2024-16-51-59"; old
experiment_folder = "SoarStabilityAnalysis-07-Jan-2025-19-05-37";

logDat = fullfile(thisFolder, experimentName, ...
    experiment_folder, "simOut_SoarStabilityAnalysis.mat");
load(logDat);

% pick correct data;
tauA = simLogs{1}.Values.Aerodynamics.aerodynamic_torque_B_B__Nm;
tauDes = simLogs{6}.Values.ActuatorsCommands.ReactionWheels.torque_commanded__Nm;
etas = simLogs{4}.Values.ActuatorsOutputs.AeroSurfaces.aero_surfaces_angles__rad;
qe = simLogs{6}.Values.ControlStates.error_attitude_quaternion_BI;
eul_BO = simLogs{3}.Values.DynamicsOutputs.RigidBody.attitude_euler_BO__rad;
om_err = simLogs{6}.Values.ControlStates.error_angular_velocity_BI_B__rad_per_s; 

% Set up figure
f1 = figure(12345); clf;
set(f1, 'Color', 'w', 'Position', [100, 100, 1000, 900]); % Adjust for 2-column width

% % Subplot 1: Attitude (quaternion)
% subplot(2, 2, 1); hold on;
% plot(qe.Time, qe.Data(:,1), 'LineWidth', lineWidth, 'DisplayName', 'q_{e,4}');
% plot(qe.Time, qe.Data(:,2), 'LineWidth', lineWidth, 'DisplayName', 'q_{e,1}');
% plot(qe.Time, qe.Data(:,3), 'LineWidth', lineWidth, 'DisplayName', 'q_{e,2}');
% plot(qe.Time, qe.Data(:,4), 'LineWidth', lineWidth, 'DisplayName', 'q_{e,3}');
% grid on;
% set(gca, 'FontName', fontName, 'FontSize', fontSizeTicks, 'LineWidth', axesLineWidth);
% xlabel('t (s)', 'FontName', fontName, 'FontSize', fontSizeLabel);
% ylabel('q_e', 'FontName', fontName, 'FontSize', fontSizeLabel);
% legend('show', 'Location', 'best', 'FontName', fontName, 'FontSize', fontSizeLegend);

% Subplot 1: Attitude (Euler BO)
subplot(2, 2, 1); hold on;
plot(eul_BO.Time, rad2deg(eul_BO.Data(:,3)), 'LineWidth', lineWidth, 'DisplayName', '\phi');
plot(eul_BO.Time, rad2deg(eul_BO.Data(:,2)), 'LineWidth', lineWidth, 'DisplayName', '\theta');
plot(eul_BO.Time, rad2deg(eul_BO.Data(:,1)), 'LineWidth', lineWidth, 'DisplayName', '\psi');
grid on;
set(gca, 'FontName', fontName, 'FontSize', fontSizeTicks, 'LineWidth', axesLineWidth);
xlabel('t (s)', 'FontName', fontName, 'FontSize', fontSizeLabel);
xlim([0 900]);
ylabel('Euler angles [°]', 'FontName', fontName, 'FontSize', fontSizeLabel);
legend('show', 'Location', 'best', 'FontName', fontName, 'FontSize', fontSizeLegend);



% Subplot 2: Torque desired vs. aerodynamic
subplot(2, 2, 2); hold on;
plot(tauA.Time(20:end), tauA.Data(20:end,1), 'color', blue, 'LineWidth', lineWidth, 'DisplayName', '\tau_{A,x}');
plot(tauDes.Time, tauDes.Data(:,1), 'color', blue, 'LineStyle','--', 'LineWidth', lineWidth, 'DisplayName', '\tau_{des,x}');
plot(tauA.Time(20:end), tauA.Data(20:end,2), 'color', red, 'LineWidth', lineWidth, 'DisplayName', '\tau_{A,y}');
plot(tauDes.Time, tauDes.Data(:,2), 'color', red,  'LineStyle','--','LineWidth', lineWidth, 'DisplayName', '\tau_{des,y}');
plot(tauA.Time(20:end), tauA.Data(20:end,3), 'color', yellow, 'LineWidth', lineWidth, 'DisplayName', '\tau_{A,z}');
plot(tauDes.Time, tauDes.Data(:,3), 'color', yellow,  'LineStyle','--','LineWidth', lineWidth, 'DisplayName', '\tau_{des,z}');
grid on;
xlim([0 500]);
set(gca, 'FontName', fontName, 'FontSize', fontSizeTicks, 'LineWidth', axesLineWidth);
xlabel('t (s)', 'FontName', fontName, 'FontSize', fontSizeLabel);
ylabel('\tau [Nm]', 'FontName', fontName, 'FontSize', fontSizeLabel);
legend('show', 'Location', 'best', 'FontName', fontName, 'FontSize', fontSizeLegend);

% Subplot 3: Fin angles over time
subplot(2, 2, 3); hold on;
plot(etas.Time, rad2deg(etas.Data(:,2)), 'LineWidth', lineWidth, 'DisplayName', '\eta_{1}');
plot(etas.Time, rad2deg(etas.Data(:,3)), 'LineWidth', lineWidth, 'DisplayName', '\eta_{2}');
plot(etas.Time, rad2deg(etas.Data(:,4)), 'LineWidth', lineWidth, 'DisplayName', '\eta_{3}');
plot(etas.Time, rad2deg(etas.Data(:,5)), 'LineWidth', lineWidth, 'DisplayName', '\eta_{4}');
grid on;
set(gca, 'FontName', fontName, 'FontSize', fontSizeTicks, 'LineWidth', axesLineWidth);
xlim([0 900]);
xlabel('t (s)', 'FontName', fontName, 'FontSize', fontSizeLabel);
ylabel('Fin angle [°]', 'FontName', fontName, 'FontSize', fontSizeLabel);
legend('show', 'Location', 'best', 'FontName', fontName, 'FontSize', fontSizeLegend);


% Subplot 3: errors of rates omega_BI_B
subplot(2, 2, 4); hold on;
plot(om_err.Time, rad2deg(om_err.Data(:,1)), 'LineWidth', lineWidth, 'DisplayName', '\omega_{e,1}');
plot(om_err.Time, rad2deg(om_err.Data(:,2)), 'LineWidth', lineWidth, 'DisplayName', '\omega_{e,2}');
plot(om_err.Time, rad2deg(om_err.Data(:,3)), 'LineWidth', lineWidth, 'DisplayName', '\omega_{e,3}');
grid on;
set(gca, 'FontName', fontName, 'FontSize', fontSizeTicks, 'LineWidth', axesLineWidth);
xlim([0 900]);
xlabel('t (s)', 'FontName', fontName, 'FontSize', fontSizeLabel);
ylabel('angular velocity [°/s]', 'FontName', fontName, 'FontSize', fontSizeLabel);
legend('show', 'Location', 'best', 'FontName', fontName, 'FontSize', fontSizeLegend);



cleanfigure;
matlab2tikz('../../../paper/Figures/case_study_small_angle.tikz', 'width','15cm','height','7cm') % for small angle figure
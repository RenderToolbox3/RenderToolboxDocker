%%% RenderToolbox3 Copyright (c) 2012-2013 The RenderToolbox3 Team.
%%% About Us://github.com/DavidBrainard/RenderToolbox3/wiki/About-Us
%%% RenderToolbox3 is released under the MIT License.  See LICENSE.txt.
%
% Set up machine-specific RenderToolbox3 configuration, like where to write
% output files and renderer configuration.
%
% This script is intended as a template only.  You should make a copy of
% this script and save it in a folder separate from RenderToolbox3.  You
% should customize that copy with values that are specific to your machine.
%
% The goal of this script is to set Matlab preference values that
% you want to use for your machine.  These include file paths where
% RenderToolbox3 should write ouptut files, and renderer-specific
% preferences for the renderers you want to use.
%
% When you first install RenderToolbox3, you should copy this script,
% customize it, and run it.  You can run it again, any time you want to
% make sure your RenderToolbox3 preferences are correct.
%
% After you run this script, you can run RenderToolbox3InstallationTest()
% to verify that your configuration is good.
%
% You can also run TestAllExampleScenes(), followed by
% CompareAllExampleScenes() to check example renderings for correctness.
%

%% Tell RenderToolbox3 where to save outputs.
matlabUserPath = '/home/docker/matlab/';
mkdir(matlabUserPath);
userpath(matlabUserPath);

%% Add toolboxes to the Matlab path.
addpath(genpath('/home/docker/Psychtoolbox-3'));
addpath(genpath('/home/docker/RenderToolbox3'));
CleanMatlabPath();

%% Start with RenderToolbox3 "fresh out of the box" configuration.
InitializeRenderToolbox(true);

%% Tell RenderToolbox3 where to save outputs.
myFolder = fullfile(GetUserFolder(), 'render-toolbox');

% set folders for temp, data, and image outputs
setpref('RenderToolbox3', 'workingFolder', myFolder);

%% Set Up Mitsuba Preferences.
if ispref('Mitsuba')
    % delete any stale preferences
    rmpref('Mitsuba');
end

% choose the file with default adjustments
adjustmentsFile = fullfile(RenderToolboxRoot(), ...
    'RendererPlugins', 'Mitsuba', 'MitsubaDefaultAdjustments.xml');

% choose the default scale factor for radiance units
radiometricScaleFactor = 0.0795827427;

% use the default executable paths
myMistubaExecutable = '/usr/local/bin/mitsuba-multi';
myMistubaImporter = '/usr/local/bin/mtsimport-multi';

% save preferences for Mitsuba
setpref('Mitsuba', 'adjustments', adjustmentsFile);
setpref('Mitsuba', 'radiometricScaleFactor', radiometricScaleFactor);
setpref('Mitsuba', 'app', '');
setpref('Mitsuba', 'executable', myMistubaExecutable);
setpref('Mitsuba', 'importer', myMistubaImporter);


%% Set Up PBRT Preferences.
if ispref('PBRT')
    % delete any stale preferences
    rmpref('PBRT');
end

% choose the file with default adjustments
adjustmentsFile = fullfile(RenderToolboxRoot(), ...
    'RendererPlugins', 'PBRT', 'PBRTDefaultAdjustments.xml');

% choose the default scale factor for radiance units
radiometricScaleFactor = 0.0063831432;

% choose spectral sampling
%   which was sepcified at PBRT compile time
S = [400 10 31];

% use the default path for PBRT
myPBRT = '/usr/local/bin/pbrt';

% save preferences for Mitsuba
setpref('PBRT', 'adjustments', adjustmentsFile);
setpref('PBRT', 'radiometricScaleFactor', radiometricScaleFactor);
setpref('PBRT', 'S', S);
setpref('PBRT', 'executable', myPBRT);

%% Set Up Another renderer.
% renderer-specific preferences for any other renderers...

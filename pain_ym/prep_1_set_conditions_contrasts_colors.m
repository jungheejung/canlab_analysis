%% Set up conditions 
% ------------------------------------------------------------------------

% conditions = {'C1' 'C2' 'C3' 'etc'};
% structural_wildcard = {'c1*nii' 'c2*nii' 'c3*nii' 'etc*nii'};
% functional_wildcard = {'fc1*nii' 'fc2*nii' 'fc3*nii' 'etc*nii'};
% colors = {'color1' 'color2' 'color3' etc}  One per condition

fprintf('Image data should be in /data folder\n');

DAT = struct();

% Names of conditions
% A "condition" usually corresponds to a regressor (beta/COPE image) in a first-level 
% (single-subject) analysis. You will usually have one image per condition per subject.
% You will have the opporunity below to specify contrasts across these
% conditions, which are estimated as part of the prep_ scripts.  
% For example, if you have a task with three types of stimuli, "pain"
% "nausea" and "itch", there would be 3 conditions. 
%
% Within-subjects design:  If this is a within-person design
% (each person experiences all three conditions), you would have 3 images
% per subject in your "data" subfolder for this study. When the images are
% loaded (later, by the prep_2_... script) the subject images should be in
% the same order for each of the three conditions. 
%
% Between-subjects design:  If this is a between-person design, you would have 3 groups 
% of subjects with one image each. You may have different numbers of
% subjects in each condition.
% 
% Designs with multiple events per task condition: Sometimes, you may have
% multiple images corresponding to the same task/trial type. For example,
% you might have 4 levels of "pain", or "early pain" and "late pain".  It
% is recommended to enter each level as a separate "condition". You can
% later create contrasts, e.g., linear contrast across 4 pain levels, or
% "early vs. late". 

% Enter a cell array { } with one cell per condition.  Each cell should
% contain a string specifying the condition name to be used in plots and
% tables. This does not have to correspond to an image/directory name.

DAT.conditions = {'scan1_pain_cue' 'scan1_no_pain_cue' 'scan1_pain_shock' 'scan1_no_pain_shock' 'scan2_pain_cue' 'scan2_no_pain_cue' 'scan2_pain_shock' 'scan2_no_pain_shock'};

DAT.conditions = format_strings_for_legend(DAT.conditions);

% SPECIFYING IMAGE FILE LOCATIONS FOR EACH CONDITION
% ------------------------------------------------------------------------
% The next lines of code specify how to locate the image files associated
% with each condition.  The image load script (i.e., prep_2...m) will attempt to use
% the file system (mac osx/windows/linux) to list the files and store them
% in a cell array of strings, with each string containing the full path name 
% for a valid image.  Images will be listed in the order in which the file
% system lists them.  
% For each condition, the prep_2...m script will construct a string containing
% wildcards (*, ?, [1-9], etc.) that can help you flexibly specify the location of 
% image.  The string is fullfile(datadir, DAT.subfolders{i}, DAT.functional_wildcard{i}),
% where i is the condition number and datadir is the path to the main
% "data" subfolder.
%
% EXAMPLES:
% Here is an example.  Say you have a subfolder in [basedir]/data 
% called 'SAC_NRFX/contrast_2', which contains one image per person, 
% named con_2_subj01.img, con_2_subj02.img, etc.  
% You could enter 'SAC_NRFX/contrast_2' in the .subfolders field below, 
% and 'con*img' in the functional_wildcard field below, and the result
% would be that we'd list files in
% [basedir]/data/SAC_NRFX/contrast_2/con*img.
%
% In a second example, say you have a subfolder in [basedir]/data for each
% subject. Inside that folder are images called "pain.nii" and "itch.nii"
% You could enter '*' in the .subfolders field below, 
% and 'pain.nii' in the functional_wildcard field for condition 1, and "itch.nii"
% for condition 2.  The result
% would be that we'd list files in
% [basedir]/data/*/pain.nii for condition 1, and [basedir]/data/*/itch.nii

% Names of subfolders in [basedir]/data
% Enter a cell array { } with one cell per condition.  Each cell should
% contain a string specifying the subfolder to look in for images of this
% condition. 
% If you do not have subfolders, it is OK to leave this empty, i.e., DAT.subfolders = {};

DAT.subfolders = {'pain/scan1/pain_cue' 'pain/scan1/no_pain_cue' 'pain/scan1/pain_shock' 'pain/scan1/no_pain_shock'
        'pain/scan2/pain_cue' 'pain/scan2/no_pain_cue' 'pain/scan2/pain_shock' 'pain/scan2/no_pain_shock'};
 

DAT.structural_wildcard = {};
DAT.functional_wildcard = {'*.nii.gz' '*.nii.gz' '*.nii.gz' '*.nii.gz' '*.nii.gz' '*.nii.gz' '*.nii.gz' '*.nii.gz'};

DAT.contrasts = [1 -1 0 0 0 0 0 0; 0 0 1 -1 0 0 0 0; 0 0 0 0 1 -1 0 0; 0 0 0 0 0 0 1 -1;
    1 0 0 0 -1 0 0 0; 0 1 0 0 0 -1 0 0; 0 0 1 0 0 0 -1 0; 0 0 0 1 0 0 0 -1];
    
% Descriptive names for contrasts to be used in plots and tables. Avoid
% special characters.
DAT.contrastnames = { 'scan1_paincue vs scan1_nopaincue' 'scan1_painshock vs scan1_nopainshock' 'scan2_paincue vs scan2_nopaincue' 'scan2_paincue vs scan2_nopaincue'
    'scan1_paincue vs scan2_paincue' 'scan1_nopaincue vs scan2_nopaincue' 'scan1_painshock vs scan2_painshock' 'scan1_nopainshock vs scan2_nopainshock'};

DAT.contrastnames = format_strings_for_legend(DAT.contrastnames);

% Set Colors
% ------------------------------------------------------------------------

% DAT.colors should be a cell array { } with one 3-element rgb vector
% (e.g., [1 0 0] for red) per condition.

% If you do not edit the code below it is ok; sensible default choices are already coded up. 

% There are several options for defining colors for conditions and
% contrasts, or enter your own in a cell array of length(conditions) for
% DAT.colors, and size(contrasts, 1) for DAT.contrastcolors
% It is better if contrasts have distinct colors from conditions

% Some options: scn_standard_colors, custom_colors, colorcube_colors, seaborn_colors, bucknerlab_colors

% DAT.colors = scn_standard_colors(length(DAT.conditions));
% DAT.colors = custom_colors(cm(1, :), cm(end, :), length(DAT.conditions));
% DAT.contrastcolors = custom_colors([.2 .2 .8], [.2 .8 .2], length(DAT.contrasts));

mycolors = colorcube_colors(length(DAT.conditions) + size(DAT.contrasts, 1));

DAT.colors = mycolors(1:length(DAT.conditions));

% DAT.contrastcolors should be a cell array { } with one 3-element rgb vector
% (e.g., [1 0 0] for red) per contrast.

DAT.contrastcolors = mycolors(length(DAT.conditions) + 1:length(mycolors));


disp('SET up conditions, colors, contrasts in DAT structure.');


% Set BETWEEN-CONDITION contrasts, names, and colors
% ------------------------------------------------------------------------
%    If conditions being compared include images for different subjects
%    i.e., condition{1} and condition{2} include different individuals, 
%    enter contrasts in DAT.between_condition_cons below.
%    These will be used in c2c_SVM_between_condition_contrasts.
%    You do not need to have the same number of images in each condition
%    being compared.
%    Contrasts are unpaired tests across these conditions.

% Matrix of [n contrasts x k conditions]

DAT.between_condition_cons = [1 0 0 0 -1 0 0 0; 
    0 1 0 0 0 -1 0 0;
    0 0 1 0 0 0 -1 0; 
    0 0 0 1 0 0 0 -1];

DAT.between_condition_contrastnames = {'scan1_paincue vs scan2_paincue' 'scan1_nopaincue vs scan2_nopaincue' 
    'scan1_painshock vs scan2_painshock' 'scan1_nopainshock vs scan2_nopainshock'};
          
DAT.between_condition_contrastcolors = custom_colors ([.2 .2 .8], [.2 .8 .2], size(DAT.between_condition_cons, 1));



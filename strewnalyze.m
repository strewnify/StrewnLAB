% STREWNALYZE Prepares folders and reports nearby sensors for data analysis

% Initialize
strewnconfig

% Start logging
diary([logfolder 'strewnlab_log.txt'])        
diary on 
logformat('New meteor event analysis initialized.')

% Load the event database
load_database

% Run the Event Picker
EventPicker_UI = EventPicker(sdb_Events);
waitfor(EventPicker_UI,'success')

% Get output data from UI before closing
SelectedEvent = extractBefore(EventPicker_UI.SelectedEvent,' - ');
success = EventPicker_UI.success;
CONFIDENTIAL = EventPicker_UI.CONFIDENTIAL;

% temp - old database - lookup index
select_i = find(strcmp(sdb_Events.EventID,SelectedEvent),1,'last');

% Close the Event Picker UI
EventPicker_UI.delete

if success
    logformat(sprintf('User selected "%s"',SelectedEvent),'USER')
else
    logformat(sprintf('User failed to select an event.'),'ERROR')
end

% Lookup nearby localities and suggest event names
CustomName = {'< Use a Custom Event Name >'};
[suggestions, radii] = suggest_eventnames(sdb_Events.LAT(select_i),sdb_Events.LONG(select_i),9);
if isempty(suggestions)
    suggestionsfound = false;    
else
    suggestionsfound = true;
    SuggestionList = strcat('~', num2str(radii), {'km | '},suggestions);
    SuggestionList = [CustomName; SuggestionList];
end

usersuccess = false;
while ~usersuccess

    % if nearby place names were found, allow the user to pick from list
    if suggestionsfound
        [selection_idx,usersuccess] = listdlg('ListString',SuggestionList,'SelectionMode','single','Name','Preliminary Event Naming', 'OKString','OK','PromptString','Select an Event Name:','ListSize',[300,300]);
    else
        selection_idx = 1;
    end
    
    if selection_idx == 1
        SimulationName = inputdlg('Enter a preliminary name for this event:','Custom Event Name',1,{'< Custom Name >'}); 
        SimulationName = SimulationName{1};
    else
        SimulationName = suggestions{selection_idx-1};
    end
    
    logformat(sprintf('User selected "%s" as Event Name',SimulationName),'USER')
end
clear usersuccess
clear selection_idx

% Create folders
if SelectedEvent(1) == 'S'
    SimEventID = ['Y' SelectedEvent(2:end)];
else
    SimEventID = SelectedEvent;
end
syncevent

% Print trajectory data
reportevents(sdb_Events(select_i,:))

% Find nearby sensors
NearbySensors = nearbysensors(sdb_Events.LAT(select_i),sdb_Events.LONG(select_i),sdb_Events.end_alt(select_i)/1000,sdb_Sensors);
NearbySensors(NearbySensors.Type ~= "Seismic",:)

% Open browser to event pages
if ~isempty(sdb_Events.Hyperlink1{select_i})
    system(['start ' sdb_Events.Hyperlink1{select_i}]);
end
if ~isempty(sdb_Events.Hyperlink2{select_i})
    system(['start ' sdb_Events.Hyperlink2{select_i}]);
end

%Open Google Earth, if not open
[~,temp_result] = system('tasklist /FI "imagename eq googleearh.exe" /fo table /nh'); % check if program is running
if strcmp(temp_result(1:4),'INFO') % if program is not running
    system([GoogleEarth_path ' &']); % open Google Earth
    system('TASKKILL -f -im "cmd.exe" > NUL'); % kill the random command window from previous system command
end

%Open WCT, if not open
[~,temp_result] = system('tasklist /FI "imagename eq wct.exe" /fo table /nh'); % check if program is running
if strcmp(temp_result(1:4),'INFO') % if program is not running
    system([WCT_path ' &']); % open Google Earth    
end

system('TASKKILL -f -im "cmd.exe" > NUL'); % kill random command windows from previous system commands

% clear temp variables
clear temp_*

% Stop logging
diary off

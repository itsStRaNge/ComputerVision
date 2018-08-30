function varargout = MainWindow(varargin)
% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 30-Aug-2018 13:22:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @MainWindow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% callback functions

function runButton_Callback(hObject, eventdata, handles)
set(handles.console, 'String', '');
print_console(handles.console, 'Start Process');
% load values
p = get(handles.pSlider, 'Value');
load_disparity_map = get(handles.load_disparity_map,'Value');
if load_disparity_map < 0.5
    load_disparity_map = false;
else
    load_disparity_map = true;
end
% load_motion = get(handles.load_motion, 'Value');
% if load_motion < 0.5
%     load_motion = false;
% else
%     load_motion = true;
% end

% create new image
output_img = free_viewpoint(handles.IL, handles.IR, handles.K,...
                        "p", p, "load_disparity_map", load_disparity_map, ...
                        "gui_console", handles.console);

% display new image
axes(handles.outputImage);
imshow(output_img);
title_str = strcat('P = ', num2str(p));
title(handles.outputImage,title_str);
print_console(handles.console, 'Finished');

function cameraCallibrationButton_Callback(hObject, eventdata, handles)
% load data
[File_Name, Path_Name] = uigetfile('camera_param_1.mat');
load(strcat(Path_Name, File_Name), 'camera_param');

% save data
handles.K = camera_param;
guidata(hObject,handles);

% update textbox
set(handles.cameraCallibrationText, 'String', File_Name);

function pSlider_Callback(hObject, eventdata, handles)
number = get(handles.pSlider,'Value'); 

if isempty(number)
    number = 0.5;
    print_console(handles.console, 'Input must be numerical');
elseif number < 0
    number = 0.0;
    print_console(handles.console, 'Input must be >=0');
elseif number > 1
    number = 1.0;
    print_console(handles.console, 'Input must be <= 1');
end
set(handles.pValue, 'String', num2str(number));

function loadLeftImageButton_Callback(hObject, eventdata, handles)
%load image
[File_Name, Path_Name] = uigetfile('leftimage.JPG');
axes(handles.leftImage);
IL = imread([Path_Name,File_Name]);

% save image
setappdata(parent, 'IL', IL);

% display image
imshow(handles.IL);


function loadRightImageButton_Callback(hObject, eventdata, handles)
%load image
[File_Name, Path_Name] = uigetfile('rightimage.JPG');
axes(handles.rightImage);
IR = imread([Path_Name,File_Name]);

% save image
setappdata(parent, 'IR', IR);

% display image
imshow(handles.IR);


function pValue_Callback(hObject, eventdata, handles)
str=get(hObject,'String');
number = str2double(str);

if isempty(number)
    number = 0.5;
    print_console(handles.console, 'Input must be numerical');
elseif number < 0
    number = 0.0;
    print_console(handles.console, 'Input must be >= 0');
elseif number > 1
    number = 1.0;
    print_console(handles.console, 'Input must be <= 1');
end
set(handles.pSlider, 'Value', number);
set(hObject, 'String', num2str(number));


%% Matlab generated functions
function MainWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for MainWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% load default images
handles.IL = imread('L1.JPG');
handles.IR = imread('R1.JPG');

% display images
axes(handles.leftImage);
imshow(handles.IL);
axes(handles.rightImage);
imshow(handles.IR);

% load default camera params
load('camera_param_1.mat', 'camera_param');
handles.K = camera_param;
set(handles.cameraCallibrationText, 'String', 'camera_param_1.mat');

% save data
guidata(hObject,handles);

function varargout = MainWindow_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function pValue_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function console_CreateFcn(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_disparity_map.
function load_disparity_map_Callback(hObject, eventdata, handles)
% hObject    handle to load_disparity_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of load_disparity_map

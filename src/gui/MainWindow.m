function varargout = MainWindow(varargin)
% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 26-Aug-2018 17:10:32

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

%% TODO
% auswahl der kamera parameter
% ausgabe des fortschrittes und der vergangenen zeit
% mögliche ausgabe weiterer parameter
% ausgabe bild größer anzeigen

%% callback functions

function preprocessButton_Callback(hObject, eventdata, handles)
% do preprocessing
print_console(handles.console, 'Starting Preprocessing');
[disparity_map, homography] = preprocessing(handles.IL, handles.IR, handles.K, handles.console);
handles.disparity_map = disparity_map;
handles.homography = homography;

% save disparity map
guidata(hObject,handles);
print_console(handles.console, 'Finished Preprocessing');


function runButton_Callback(hObject, eventdata, handles)
print_console(handles.console, 'Creating New Image');
p = get(handles.pSlider, 'Value');

output_img = new_view(handles.disparity_map, handles.IL, handles.IR, ...
                      get(handles.pSlider,'Value'), handles.console);

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
    warndlg('Input must be numerical');
elseif number < 0
    number = 0.0;
    warndlg('Input must be greater than 0');
elseif number > 1
    number = 1.0;
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
    warndlg('Input must be numerical');
elseif number < 0
    number = 0.0;
    warndlg('Input must be greater than 0');
elseif number > 1
    number = 1.0;
end
set(handles.pSlider, 'Value', number);


%% object created fcts
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



function console_Callback(hObject, eventdata, handles)
% hObject    handle to console (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of console as text
%        str2double(get(hObject,'String')) returns contents of console as a double


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

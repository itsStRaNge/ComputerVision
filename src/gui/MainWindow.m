function varargout = MainWindow(varargin)
% Edit the above text to modify the response to help MainWindow

% Last Modified by GUIDE v2.5 11-Sep-2018 11:02:06

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

function preproButton_Callback(hObject,eventdata,handles)
    [handles.matches,handles.E,handles.K,handles.JL,handles.JR,handles.HL,handles.HR]=preprocessing(handles.IL,handles.IR,handles.K);
    axes(handles.leftImage);
    imshow(handles.JL);
    axis off
    axes(handles.rightImage);
    imshow(handles.JR);
    axis off
    guidata(hObject,handles);
    
function runButton_Callback(hObject, eventdata, handles)
% load values
p = get(handles.pSlider, 'Value');
df = get(handles.dfSlider, 'Value');
sw = get(handles.swSlider, 'Value');
mf = get(handles.mfSlider, 'Value');

% create new image
handles.output_image = free_viewpoint(handles.IL, handles.IR, handles.K,...
                        'p', p, ...
                        'max_disp_factor', df, ...
                        'win_size_factor', sw, ...
                        'med_filt_window', mf);

% display new image
axes(handles.outputImage);
imshow(handles.output_image);
axis off
title_str = strcat('P = ', num2str(p));
title(handles.outputImage,title_str);

function synthButton_Callback(hObject,eventdata,handles)

p = get(handles.pSlider, 'Value');

fprintf('7\t Synthesising new Image\t\t 40.00s');
start = tic;
handles.output_image = synthesis_both_sides(handles.disp_left,handles.disp_right, handles.IL_resized, handles.IR_resized, p);
if(isprop(handles,'HL'))
    %image has been rectified/preprocessed
    %enable derectification
    if(p==0)
        handles.output_image=cv_inv_rectify(handles.output_image,HL);
    elseif(p==1)
        handles.output_image=cv_inv_rectify(handles.output_image,HR);
    else
        handles.matches(3:4,:)=handles.matches(1:2,:)+p*(handles.matches(3:4,:)-handles.matches(1:2,:));
        E=eight_point_algorithm(handles.matches, handles.K);
        [R, T, lambda] = motion_estimation(matches, E, K);
        [~,  ~,  ~, HomographyR] = rectification(IL_d, IR_d, R, T', K,1);
        handles.output_image=cv_inv_rectify(IM,HomographyR);

    end
end
axes(handles.leftImage);
    imshow(handles.IL);
    axis off
    axes(handles.rightImage);
    imshow(handles.IR);
    axis off
    
axes(handles.outputImage);
imshow(handles.output_image);
axis off
fprintf('\t\t%.2fs\n', toc(start));
title_str = strcat('P = ', num2str(p));
title(handles.outputImage,title_str);
guidata(hObject,handles);

    
    


function dispButton_Callback(hObject, eventdata, handles)
% load values
p = get(handles.pSlider, 'Value');
df = get(handles.dfSlider, 'Value');
sw = get(handles.swSlider, 'Value');
mf = get(handles.mfSlider, 'Value');

%check if rectified images exist
if(~isfield(handles,'JL'))
    handles.JL=handles.IL;
    handles.JR=handles.IR;
end

% create disp values

[handles.disp_left,handles.disp_right,handles.IL_resized,handles.IR_resized] = disparity_estimation(handles.JL, handles.JR,...
                        'max_disp_factor', df, ...
                        'win_size_factor', sw, ...
                        'med_filt_window', mf);

% display new image

 axes(handles.leftImage);
    imagesc(handles.disp_left);
    colormap(jet);
    axis off
    axes(handles.rightImage);
    imagesc(handles.disp_right);
    colormap(jet);
    axis off
   guidata(hObject,handles); 
    
 
 
    
function cameraCallibrationButton_Callback(hObject, eventdata, handles)
% load data
[File_Name, Path_Name] = uigetfile('camera_param_2.mat');
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
elseif number < 0
    number = 0.0;
elseif number > 1
    number = 1.0;
end
set(handles.pValue, 'String', num2str(number));

function loadLeftImageButton_Callback(hObject, eventdata, handles)
%load image
[File_Name, Path_Name] = uigetfile('leftimage.JPG');
IL = imread([Path_Name,File_Name]);

% display image
axes(handles.leftImage);
imshow(IL);

% save image
handles.IL = IL;
guidata(hObject,handles);


function loadRightImageButton_Callback(hObject, eventdata, handles)
%load image
[File_Name, Path_Name] = uigetfile('rightimage.JPG');
IR = imread([Path_Name,File_Name]);

% display image
axes(handles.rightImage);
imshow(IR);

% save image
handles.IR = IR;
guidata(hObject,handles);


function pValue_Callback(hObject, eventdata, handles)
str=get(hObject,'String');
number = str2double(str);

if isempty(number)
    number = 0.25;
elseif number < 0
    number = 0.0;
elseif number > 1
    number = 1.0;
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
handles.IL = imread('L2.JPG');
handles.IR = imread('R2.JPG');

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

% --- Executes on button press in load_disparity_map.
function load_disparity_map_Callback(hObject, eventdata, handles)
% hObject    handle to load_disparity_map (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of load_disparity_map


% --- Executes on slider movement.
function dfSlider_Callback(hObject, eventdata, handles)
number = get(handles.dfSlider,'Value'); 

if isempty(number)
    number = 0.5;
elseif number < 0
    number = 0.0;
elseif number > 1.0
    number = 1.0;
end
set(handles.dfValue, 'String', num2str(number));

% --- Executes during object creation, after setting all properties.
function dfSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dfSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function dfValue_Callback(hObject, eventdata, handles)
str=get(hObject,'String');
number = str2double(str);

if isempty(number)
    number = 0.5;
elseif number < 0
    number = 0.0;
elseif number > 1
    number = 1.0;
end
set(handles.dfSlider, 'Value', number);
set(hObject, 'String', num2str(number));


% --- Executes during object creation, after setting all properties.
function dfValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dfValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function swSlider_Callback(hObject, eventdata, handles)
number = get(handles.swSlider,'Value'); 

if isempty(number)
    number = 0.005;
elseif number < 0
    number = 0.0;
elseif number > 0.2
    number = 0.2;
end
set(handles.swValue, 'String', num2str(number));

% --- Executes during object creation, after setting all properties.
function swSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function swValue_Callback(hObject, eventdata, handles)
str=get(hObject,'String');
number = str2double(str);

if isempty(number)
    number = 0.5;
elseif number < 0
    number = 0.0;
elseif number > 1
    number = 1.0;
end
set(handles.swSlider, 'Value', number);
set(hObject, 'String', num2str(number));

% --- Executes during object creation, after setting all properties.
function swValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function mfSlider_Callback(hObject, eventdata, handles)
number = get(handles.mfSlider,'Value'); 

if isempty(number)
    number = 0.0;
elseif number < 0
    number = 0.0;
elseif number > 20.0
    number = 20.0;
end
set(handles.mfValue, 'String', num2str(number));

% --- Executes during object creation, after setting all properties.
function mfSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mfSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function mfValue_Callback(hObject, eventdata, handles)
str=get(hObject,'String');
number = str2double(str);

if isempty(number)
    number = 0.0;
elseif number < 0
    number = 0.0;
elseif number > 20
    number = 20.0;
end
set(handles.mfSlider, 'Value', number);
set(hObject, 'String', num2str(number));

% --- Executes during object creation, after setting all properties.
function mfValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mfValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

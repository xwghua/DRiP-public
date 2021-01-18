function varargout = mask_GUI(varargin)
% MASK_GUI MATLAB code for mask_GUI.fig
%      MASK_GUI, by itself, creates a new MASK_GUI or raises the existing
%      singleton*.
%
%      H = MASK_GUI returns the handle to a new MASK_GUI or the handle to
%      the existing singleton*.
%
%      MASK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASK_GUI.M with the given input arguments.
%
%      MASK_GUI('Property','Value',...) creates a new MASK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mask_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mask_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mask_GUI

% Last Modified by GUIDE v2.5 14-Jun-2017 23:05:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mask_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @mask_GUI_OutputFcn, ...
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
% Global Parameters initialization
function parameters(handles)

global Para;
Para.InnAvg = get(handles.InnAvg, 'string');
Para.OutAvg = get(handles.OutAvg, 'string');
Para.InnWid = get(handles.InnWid, 'string');
Para.OutWid = get(handles.OutWid, 'string');

Para.nval = get(handles.period, 'Value');
Para.nmin = get(handles.period, 'Min');
Para.nmax = get(handles.period, 'Max');

Para.rings = get(handles.rings, 'Value');
Para.gt = get(handles.grating, 'Value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initial_para(handles)


set(handles.InnAvg, 'string','18');
set(handles.OutAvg, 'string','40');
set(handles.InnWid, 'string','10');
set(handles.OutWid, 'string','8');

set(handles.period, 'Min',1);
set(handles.period, 'Max',100);
set(handles.period, 'Value',19);
set(handles.pval, 'string',num2str(get(handles.period, 'Value')));

set(handles.rings, 'Value',1);
set(handles.grating, 'Value',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function load_ipt(handles)

global tA;
global grating;
global masking;
global Para;
InnAvg              = str2double(Para.InnAvg);
OutAvg              = str2double(Para.OutAvg);
InnWid              = str2double(Para.InnWid);
OutWid              = str2double(Para.OutWid);
period              = Para.nval;
% set(handles.pval, 'string',num2str(get(handles.period, 'Value')));

R1                  = InnAvg-InnWid/2;      %disp(num2str(R1));
R2                  = InnAvg+InnWid/2;      %disp(num2str(R2));
R3                  = OutAvg-OutWid/2;      %disp(num2str(R3));
R4                  = OutAvg+OutWid/2;      %disp(num2str(R4));

pxx                 = 1920;
pxy                 = 1080;
magnitude           = 0.01;

x                   = linspace(-pxx*8/2,pxx*8/2,pxx);
y                   = linspace(-pxy*8/2,pxy*8/2,pxy);
[X,Y]               = meshgrid(x,y);
rho                 = sqrt((X*magnitude).^2+(Y*magnitude).^2);
% disp(num2str(min(min(rho))));
% disp(num2str(max(max(rho))));
tA                  = (rho>=R1).*(rho<=R2)+(rho>=R3).*(rho<=R4);
% disp(num2str(sum(find(tA==1))));
grating             = zeros(pxy,pxx);
for i = 1:1:pxy
    grating(i,:)    = 1/1920/4*period*mod(x,1920*4/period);
end
% disp(num2str(period));
% disp(num2str(max(max(grating))));

masking             = tA.*grating;

% figure(2000),imshow(uint8(255*tA));colormap('gray');

function fig_opt(handles)

global tA;
global grating;
global masking;
global Para;

if Para.rings == 1
    if Para.gt == 1
        imshow( uint8(255*masking) , 'parent' , handles.imdisp );
        colormap('gray');
    else
        imshow( uint8(255*tA) , 'parent' , handles.imdisp );
        colormap('gray');
    end
else
    if Para.gt == 1
        imshow( uint8(255*grating) , 'parent' , handles.imdisp );
        colormap('gray');
    end
end
% imshow( uint8(255*masking) , 'parent' , handles.imdisp );
% colormap('gray');

% End initialization code - DO NOT EDIT


% --- Executes just before mask_GUI is made visible.
function mask_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mask_GUI (see VARARGIN)

% Choose default command line output for mask_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% =======================================================================
initial_para(handles);
parameters(handles);
load_ipt(handles);
fig_opt(handles);
% =======================================================================
% UIWAIT makes mask_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mask_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function InnAvg_Callback(hObject, eventdata, handles)
% hObject    handle to InnAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parameters(handles);
load_ipt(handles);
fig_opt(handles);
% Hints: get(hObject,'String') returns contents of InnAvg as text
%        str2double(get(hObject,'String')) returns contents of InnAvg as a double


% --- Executes during object creation, after setting all properties.
function InnAvg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InnAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutAvg_Callback(hObject, eventdata, handles)
% hObject    handle to OutAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parameters(handles);
load_ipt(handles);
fig_opt(handles);
% Hints: get(hObject,'String') returns contents of OutAvg as text
%        str2double(get(hObject,'String')) returns contents of OutAvg as a double


% --- Executes during object creation, after setting all properties.
function OutAvg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function InnWid_Callback(hObject, eventdata, handles)
% hObject    handle to InnWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parameters(handles);
load_ipt(handles);
fig_opt(handles);
% Hints: get(hObject,'String') returns contents of InnWid as text
%        str2double(get(hObject,'String')) returns contents of InnWid as a double


% --- Executes during object creation, after setting all properties.
function InnWid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InnWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutWid_Callback(hObject, eventdata, handles)
% hObject    handle to OutWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parameters(handles);
load_ipt(handles);
fig_opt(handles);
% Hints: get(hObject,'String') returns contents of OutWid as text
%        str2double(get(hObject,'String')) returns contents of OutWid as a double


% --- Executes during object creation, after setting all properties.
function OutWid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutWid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function period_Callback(hObject, eventdata, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tA;
global grating;
global masking;
global Para;

Para.nval           = get(handles.period, 'Value'); % return position of the slider
set(handles.pval, 'string',num2str(get(handles.period, 'Value')));
period              = Para.nval;
pxx                 = 1920;
pxy                 = 1080;
% magnitude           = 0.01;

x                   = linspace(-pxx*8/2,pxx*8/2,pxx);
% y                   = linspace(-pxy*8/2,pxy*8/2,pxy);
% [X,Y]               = meshgrid(x,y);
% rho                 = sqrt((X*magnitude).^2+(Y*magnitude).^2);

grating             = zeros(pxy,pxx);
for i = 1:1:pxy
    grating(i,:)    = 1/1920/4*period*mod(x,1920*4/period);
end
masking             = tA.*grating;

fig_opt(handles);
% imshow( uint8(255*masking) , 'parent' , handles.imdisp );
% colormap 'gray';
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in startrun.
% function startrun_Callback(hObject, eventdata, handles)
% hObject    handle to startrun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ======================================================================
% parameters(handles);
% load_ipt(handles);
% fig_opt(handles);
% ======================================================================

% --- Executes on button press in rings.
function rings_Callback(hObject, eventdata, handles)
% hObject    handle to rings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Para;
Para.rings = get(handles.rings, 'Value');
Para.gt = get(handles.grating, 'Value');
fig_opt(handles);
% Hint: get(hObject,'Value') returns toggle state of rings


% --- Executes on button press in grating.
function grating_Callback(hObject, eventdata, handles)
% hObject    handle to grating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Para;
Para.rings = get(handles.rings, 'Value');
Para.gt = get(handles.grating, 'Value');
fig_opt(handles);
% Hint: get(hObject,'Value') returns toggle state of grating



function pval_Callback(hObject, eventdata, handles)
% hObject    handle to pval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
period_val = str2double(get(handles.pval, 'String'));
if period_val >= 1
    if period_val <=100
        set(handles.period, 'Value',period_val);
    else
        set(handles.period, 'Value',100);
        set(handles.pval, 'String', 'ERR/RST2MAX:100');
    end
else
    set(handles.period, 'Value',1);
    set(handles.pval, 'String', 'ERR/RST2MIN:1');
end

global tA;
global grating;
global masking;
global Para;

Para.nval           = get(handles.period, 'Value'); % return position of the slider
period              = Para.nval;
pxx                 = 1920;
pxy                 = 1080;
% magnitude           = 0.01;

x                   = linspace(-pxx*8/2,pxx*8/2,pxx);
% y                   = linspace(-pxy*8/2,pxy*8/2,pxy);
% [X,Y]               = meshgrid(x,y);
% rho                 = sqrt((X*magnitude).^2+(Y*magnitude).^2);

grating             = zeros(pxy,pxx);
for i = 1:1:pxy
    grating(i,:)    = 1/1920/4*period*mod(x,1920*4/period);
end
masking             = tA.*grating;

fig_opt(handles);
% Hints: get(hObject,'String') returns contents of pval as text
%        str2double(get(hObject,'String')) returns contents of pval as a double


% --- Executes during object creation, after setting all properties.
function pval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

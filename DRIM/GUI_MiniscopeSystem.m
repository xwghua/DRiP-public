function varargout = GUI_MiniscopeSystem(varargin)
%GUI_MINISCOPESYSTEM M-file for GUI_MiniscopeSystem.fig
%      GUI_MINISCOPESYSTEM, by itself, creates a new GUI_MINISCOPESYSTEM or raises the existing
%      singleton*.
%
%      H = GUI_MINISCOPESYSTEM returns the handle to a new GUI_MINISCOPESYSTEM or the handle to
%      the existing singleton*.
%
%      GUI_MINISCOPESYSTEM('Property','Value',...) creates a new GUI_MINISCOPESYSTEM using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_MiniscopeSystem_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_MINISCOPESYSTEM('CALLBACK') and GUI_MINISCOPESYSTEM('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_MINISCOPESYSTEM.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_MiniscopeSystem

% Last Modified by GUIDE v2.5 19-Apr-2017 14:21:26

% Begin initialization code - DO NOT EDIT
% clear all;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_MiniscopeSystem_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_MiniscopeSystem_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)

global settingPSF;
settingPSF.Pixel_X = get(handles.edit_Pixel_X, 'string');
settingPSF.Pixel_Y = get(handles.edit_Pixel_Y, 'string');
settingPSF.Pixel_Z = get(handles.edit_Pixel_Z, 'string');
settingPSF.Length_GRIN = get(handles.edit_Length_GRIN, 'string');
settingPSF.Diameter_GRIN = get(handles.edit_Diameter_GRIN, 'string');
settingPSF.lambda = get(handles.edit_lambda, 'string');
settingPSF.n0 = get(handles.edit_n0, 'string');
settingPSF.g = get(handles.edit_g, 'string');
settingPSF.Diameter_Input = get(handles.edit_Diameter_Input, 'string');

settingPSF.Slider_X_Value = get(handles.slider_X,'Value')   %returns position of slider
settingPSF.Slider_X_Min = get(handles.slider_X,'Min') 
settingPSF.Slider_X_Max = get(handles.slider_X,'Max')     %to determine range of slider


settingPSF.Slider_Y_Value = get(handles.slider_Y,'Value')   %returns position of slider
settingPSF.Slider_Y_Min = get(handles.slider_Y,'Min') 
settingPSF.Slider_Y_Max = get(handles.slider_Y,'Max')     %to determine range of slider

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function InitialState(handles)

    set(handles.edit_Pixel_X, 'string', '2');
    set(handles.edit_Pixel_Y, 'string', '2');
    set(handles.edit_Pixel_Z, 'string', '200');
    set(handles.edit_Length_GRIN, 'string', '4.787');
    set(handles.edit_Diameter_GRIN, 'string', '2');    
    set(handles.edit_lambda, 'string', '550');
    set(handles.edit_n0, 'string', '1.635');
    set(handles.edit_g, 'string', '0.3281');
    set(handles.edit_Diameter_Input, 'string', '1');
    set(handles.slider_X,'Value',0); 
    set(handles.slider_Y,'Value',0); 
     set(handles.slider_Zoom,'Value',0); 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function LoadInput(handles)

     global settingPSF;
     global uu;
     global uu1;
        Pixel_X          = str2num(settingPSF.Pixel_X)*1e-6;
        Pixel_Y          = str2num(settingPSF.Pixel_Y)*1e-6;
        Pixel_Z          = str2num(settingPSF.Pixel_Z)*1e-6;
        Length_GRIN      = str2num(settingPSF.Length_GRIN)*1e-3;
        Diameter_GRIN    = str2num(settingPSF.Diameter_GRIN)*1e-3;
        lambda           = str2num(settingPSF.lambda)*1e-9;
        n0               = str2num(settingPSF.n0);
        g                = str2num(settingPSF.g)*1e3;
        Diameter_Input   = str2num(settingPSF.Diameter_Input)*1e-3;
    
        
        k0               = 2*pi/lambda;
        Beta2            = (1)/(1*k0*n0);
        Size_X           = round(Diameter_GRIN/Pixel_X)
        Size_Y           = round(Diameter_GRIN/Pixel_Y)
        Size_Z           = round( Length_GRIN/Pixel_Z )
        
        Size_Zeropadding = Size_Y*1;
        
        settingPSF.Size_X       = Size_Zeropadding;
         settingPSF.Size_Y       = Size_Zeropadding;
        
        
        Size_Z_Air       = 20;
        

        
        Nr               = zeros( Size_X  ,Size_Y  );

        Center_X         = round(Size_X/2);
        Center_Y         = round(Size_Y/2);

        r                = Gen_RotionalSymmetryMatrix(Nr, Pixel_X , Pixel_Y);
        Nr               = n0*sech(1*g*r).*(r<=Diameter_GRIN/2 );
        Nr               = Nr + (r>Diameter_GRIN/2 );
        Nr_Z             = Zeropadding_Valueone( Nr , Size_Zeropadding,Size_Zeropadding); 
        
        
        
        nx               = Size_Zeropadding;
        step_num         = Size_Z;
        deltaz           = Pixel_Z;
        dx               = Pixel_X;
        dy               = Pixel_Y;
        Xmax             = dx*nx/1;

        X_grid           = (-nx/2:nx/2-1); 
        [X_2D , Y_2D]    = meshgrid(X_grid , X_grid);

        uu_r             = Gen_RotionalSymmetryMatrix(Nr_Z, Pixel_X , Pixel_Y);
        uu               = (uu_r<Diameter_Input/2)*255;
       
        imshow( uint8(abs(uu)/max(max(abs(uu)))*255) , 'parent' , handles.Figure_Input );
        colormap 'hot';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StartLoadParameters(handles)
   
   
    global settingPSF;
    global uu;
    global uu1;
    
      figure(5000)
      imshow( uint8(abs(uu1)/max(max(abs(uu1)))*255)  );
      colormap 'hot';
        Pixel_X          = str2num(settingPSF.Pixel_X)*1e-6;
        Pixel_Y          = str2num(settingPSF.Pixel_Y)*1e-6;
        Pixel_Z          = str2num(settingPSF.Pixel_Z)*1e-6;
        Length_GRIN      = str2num(settingPSF.Length_GRIN)*1e-3;
        Diameter_GRIN    = str2num(settingPSF.Diameter_GRIN)*1e-3;
        lambda           = str2num(settingPSF.lambda)*1e-9;
        n0               = str2num(settingPSF.n0);
        g                = str2num(settingPSF.g)*1e3;
        Diameter_Input   = str2num(settingPSF.Diameter_Input)*1e-3;
    
        k0               = 2*pi/lambda;
        Beta2            = (1)/(1*k0*n0);
        Size_X           = round(Diameter_GRIN/Pixel_X)
        Size_Y           = round(Diameter_GRIN/Pixel_Y)
        Size_Z           = round( Length_GRIN/Pixel_Z )
        
        Size_Zeropadding = Size_Y*1;
        Size_Z_Air       = 20;
        

        
        Nr               = zeros( Size_X  ,Size_Y  );

        Center_X         = round(Size_X/2);
        Center_Y         = round(Size_Y/2);

        r                = Gen_RotionalSymmetryMatrix(Nr, Pixel_X , Pixel_Y);
        Nr               = n0*sech(1*g*r).*(r<=Diameter_GRIN/2 );
        Nr               = Nr + (r>Diameter_GRIN/2 );
        Nr_Z             = Zeropadding_Valueone( Nr , Size_Zeropadding,Size_Zeropadding); 
        
        
        
        nx               = Size_Zeropadding;
        step_num         = Size_Z;
        deltaz           = Pixel_Z;
        dx               = Pixel_X;
        dy               = Pixel_Y;
        Xmax             = dx*nx/1;

        X_grid           = (-nx/2:nx/2-1); 
        [X_2D , Y_2D]    = meshgrid(X_grid , X_grid);
% 
%         uu_r             = Gen_RotionalSymmetryMatrix(Nr_Z, Pixel_X , Pixel_Y);
        


%         uu               = (uu_r<Diameter_Input/2)*255;
%         
%         imshow( uint8(abs(uu)/max(max(abs(uu)))*255) , 'parent' , handles.Figure_Input );
        
        
        omega            = (2*pi/Xmax)*[(0:nx/2-1) (-nx/2:-1)];  
        omega_X          = [(0:nx/2-1) (-nx/2:-1)];           
        [omega_2D_X , omega_2D_Y] = meshgrid(omega_X , omega_X);
        omega_2D_X       = omega_2D_X*(2*pi/Xmax);
        omega_2D_Y       = omega_2D_Y*(2*pi/Xmax);


        dispersion       = exp(  -i*1/2*Beta2*(omega_2D_X.^2+omega_2D_Y.^2 )  *deltaz*1  );
        hhz              = 1i/2*k0*( n0^2 - Nr_Z.^2 )./n0*deltaz.*1;  

        

        temp            = uu1.*exp(hhz/2);
        
        for Num_z       = 1:(Size_Z)


                hhz        = 1i/2*k0*( n0^2 - (Nr_Z).^2 )./n0*deltaz.*1; ;  %1i*k0*( Nr_Z-n0 )*delt
                f_temp     = ifft2(temp).*dispersion;
                uu1         = fft2(f_temp);
                temp       = uu1.*exp(-hhz/1);
                Light_Focus(:,:,Num_z) = temp;
                Num_z

        end


Light_Focus_abs   = abs(Light_Focus);
Light_Focus_abs_XZ   = sum( Light_Focus_abs ,  2);
Light_Focus_abs_YZ   = sum( Light_Focus_abs ,  1);
Light_Focus_abs_Profile_XZ     = reshape(  Light_Focus_abs_XZ( : , 1 , :),[ Size_Zeropadding, Size_Z+0+0]    );
Light_Focus_abs_Profile_XZ     = imresize(Light_Focus_abs_Profile_XZ,[2000 6000]);

Light_Focus_abs_Profile_YZ     = reshape(  Light_Focus_abs_YZ( 1 , : , :),[ Size_Zeropadding, Size_Z+0+0]    );
Light_Focus_abs_Profile_YZ     = imresize(Light_Focus_abs_Profile_YZ,[2000 6000]);



Light_FWHM     =  Light_Focus_abs( : , : , Size_Z)/max(max(Light_Focus_abs( : , : , Size_Z)));

[MaxValue Column_Num] = max(max( Light_FWHM ) );
[MaxValue Row_Num] = max(max( Light_FWHM' ) );

settingPSF.Row_Num = Row_Num;
settingPSF.Column_Num = Column_Num;

FWHM_Curve = Light_FWHM( Row_Num , : );
FWHM_Curve_Zoom = FWHM_Curve;

settingPSF.FWHM_Curve_Zoom = FWHM_Curve_Zoom;

plot( FWHM_Curve , 'parent' , handles.Figure_FWHM );
plot( FWHM_Curve_Zoom ,'r--o', 'parent' , handles.Figure_FWHM_Zoom );


figure(1000)
imshow( uint8(Light_Focus_abs_Profile_XZ/max(max(Light_Focus_abs_Profile_XZ))*255) );
colormap 'hot';
figure(2000)
imshow( uint8(Light_Focus_abs_Profile_YZ/max(max(Light_Focus_abs_Profile_YZ))*255) );
colormap 'hot';
figure(3000)
imshow( uint8(Light_Focus_abs(:,:,Size_Z)/max(max(Light_Focus_abs(:,:,Size_Z)))*255)  );
colormap 'hot';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes just before GUI_MiniscopeSystem is made visible.
function GUI_MiniscopeSystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI_MiniscopeSystem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

InitialState(handles);
  readState(handles);
     LoadInput(handles);    




% UIWAIT makes GUI_MiniscopeSystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_MiniscopeSystem_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_Pixel_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pixel_X as text
% Pixel_X=str2double(get(hObject,'String')); %returns contents of edit_Pixel_X as a double


% --- Executes during object creation, after setting all properties.
function edit_Pixel_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Pixel_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pixel_Y as text
% Pixel_Y=str2double(get(hObject,'String')); %returns contents of edit_Pixel_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Pixel_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Pixel_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pixel_Z as text
% Pixel_Z=str2double(get(hObject,'String'));% returns contents of edit_Pixel_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Pixel_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pixel_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Length_GRIN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Length_GRIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Length_GRIN as text
% Length_GRIN = str2double(get(hObject,'String'));% returns contents of edit_Length_GRIN as a double


% --- Executes during object creation, after setting all properties.
function edit_Length_GRIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Length_GRIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Diameter_GRIN_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Diameter_GRIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Diameter_GRIN as text
% Diameter_GRIN = str2double(get(hObject,'String'));% returns contents of edit_Diameter_GRIN as a double


% --- Executes during object creation, after setting all properties.
function edit_Diameter_GRIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Diameter_GRIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lambda as text
% lambda = str2double(get(hObject,'String'));% returns contents of edit_lambda as a double


% --- Executes during object creation, after setting all properties.
function edit_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_n0_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n0 as text
% n0 = str2double(get(hObject,'String'));% returns contents of edit_n0 as a double


% --- Executes during object creation, after setting all properties.
function edit_n0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_g_Callback(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_g as text
% g = str2double(get(hObject,'String'));% returns contents of edit_g as a double


% --- Executes during object creation, after setting all properties.
function edit_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Diameter_Input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Diameter_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Diameter_Input as text
% Diameter_Input = str2double(get(hObject,'String'));% returns contents of edit_Diameter_Input as a double
readState(handles)
     LoadInput(handles);
    
slider_X_Callback(hObject, eventdata, handles);
slider_Y_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function edit_Diameter_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Diameter_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% close handles.Figure_XZ;
% close handles.Figure_YZ;
% close handles.Figure_Input;
% close handles.Figure_Output;
% close handles.Figure_FWHM;
% close handles.Figure_FWHM_Zoom;

     readState(handles);
     LoadInput(handles);
    
slider_X_Callback(hObject, eventdata, handles);
slider_Y_Callback(hObject, eventdata, handles);
 StartLoadParameters(handles);
% --- Executes on slider movement.
function slider_X_Callback(hObject, eventdata, handles)
% hObject    handle to slider_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  global uu;
  global uu1;
  global settingPSF;

    settingPSF.Slider_X_Value = get(handles.slider_X,'Value')   %returns position of slider
   
    X_Shift        =  settingPSF.Slider_X_Value;
    Input_Size_X   = settingPSF.Size_X;
    Num_shift_X    = round( X_Shift*Input_Size_X );
    
    settingPSF.Slider_Y_Value = get(handles.slider_Y,'Value')   %returns position of slider
     
    Y_Shift        =  settingPSF.Slider_Y_Value;
    Input_Size_Y   = settingPSF.Size_Y;
    Num_shift_Y    = round( Y_Shift*Input_Size_Y );
    
    uu1            = circshift( uu , [Num_shift_Y   Num_shift_X]);
    imshow( uint8(abs(uu1)/max(max(abs(uu1)))*255) , 'parent' , handles.Figure_Input );
    colormap 'hot';
        
        


% --- Executes during object creation, after setting all properties.
function slider_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_Y_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLABDiameter_Input
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
  global uu;
  global uu1;
  global settingPSF;

  
   settingPSF.Slider_Y_Value = get(handles.slider_Y,'Value')   %returns position of slider
     
   Y_Shift        =  settingPSF.Slider_Y_Value;
   Input_Size_Y   = settingPSF.Size_Y;
   Num_shift_Y    = round( Y_Shift*Input_Size_Y );
   
    settingPSF.Slider_X_Value = get(handles.slider_X,'Value')   %returns position of slider
   
    X_Shift        =  settingPSF.Slider_X_Value;
    Input_Size_X   = settingPSF.Size_X;
    Num_shift_X    = round( X_Shift*Input_Size_X );
   
   uu1            = circshift( uu , [ Num_shift_Y Num_shift_X]);
   imshow( uint8(abs(uu1)/max(max(abs(uu1)))*255) , 'parent' , handles.Figure_Input );
   colormap 'hot';
        
        
% --- Executes during object creation, after setting all properties.
function slider_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_Zoom_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global settingPSF;
FWHM_Curve_Zoom = settingPSF.FWHM_Curve_Zoom;
Row_Num = settingPSF.Row_Num;
Column_Num = settingPSF.Column_Num;
Size_Zeropadding = settingPSF.Size_Y;
Zoom_Value = get(hObject,'Value');
Zoom_Num   =   round(Column_Num)-round( Zoom_Value*round(Column_Num) );
Start_Min  = round(Column_Num)-Zoom_Num;
End_Max    = min(  round(Column_Num)+Zoom_Num , Size_Zeropadding);
FWHM_Curve_Zoom_sub = FWHM_Curve_Zoom( Start_Min :  End_Max);
plot( FWHM_Curve_Zoom_sub ,'r--o', 'parent' , handles.Figure_FWHM_Zoom );



% --- Executes during object creation, after setting all properties.
function slider_Zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

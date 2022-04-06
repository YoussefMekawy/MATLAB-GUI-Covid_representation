function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 24-Mar-2022 21:36:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)

% Choose default command line output for project
handles.output = hObject;

%%load data base and creat new fields
load covid_data.mat
handles.All_Data = covid_data;
handles.countery_colume = ["Global";string(covid_data(2:end,1))];
handles.states_colume = ["";string(covid_data(2:end,2))];
handles.countery_Non_Dup = remove_duplicate(handles.countery_colume);
handles.counter_num = 1;
handles.current_countery_num = 1;
handles.str = "Global";
handles.Data_plot = "Cases";
handles.option = "Cumulative";
handles.average_days = '1';
handles.current_state_num = 1;
handles.Daily_Data = 0;
handles.Daily_Data_Deaths = 0;
[handles.Global_Cases_Cumulative,handles.Global_Deathes_Cumulative,handles.Global_Cases_Daily,handles.Global_Deathes_Daily]...
          = Calc_Global(handles.All_Data);

Plotting_Fun(handles);

%%days
% handles.d1 = datetime('22/01/2020','InputFormat','dd/MM/uuuu');
% handles.d2 = datetime('30/01/2021','InputFormat','dd/MM/uuuu');
% % handles.days = d1:1:d2;

%%set up counters List
set(handles.List,'String',handles.countery_Non_Dup);
set(handles.List,'Value',1);

%%set up states List
set(handles.List2,'String','All');

%%set up slider
set(handles.slider1,'Value',0);
set(handles.slider1, 'SliderStep', [1/(15-1) , 10/(15-1) ]);

%%set edit text value of slider
% set(handles.value,'String',1);

%%set Data to Plot
set(handles.uibuttongroup1.Children(3),'Value',1);

%%set Option
set(handles.uibuttongroup2.Children(2),'Value',1);

%%set axes
axes(handles.axes1)
handles.axes1.Title.String = ('Cumulative Number of Cases Globaly (1-day mean)');
handles.axes1.Title.Color = [0,0,0];
handles.axes1.XGrid = 1;
handles.axes1.YGrid = 1;
% grid on

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in List.
function List_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset

handles.counter_num = get(handles.List,'Value');
set(handles.List2,'Value',1);
handles.current_countery_num = get_list_num(handles.countery_colume,handles.countery_Non_Dup(handles.counter_num));
handles.states_list = search_data(handles.countery_colume,handles.countery_Non_Dup,handles.states_colume,handles.counter_num);
set(handles.List2,'string',handles.states_list)

Plotting_Fun(handles);

if(handles.counter_num~=1)
          handles.str = handles.countery_Non_Dup(handles.counter_num);
          handles.axes1.Title.String = ([char(handles.option) ' Number of ' char(handles.Data_plot) ' in '...
                                        char(handles.countery_Non_Dup(handles.counter_num)) ' (' char(handles.average_days) '-day mean)']);
else
          handles.str = 'Global'; 
          handles.axes1.Title.String = ([char(handles.option) ' Number of ' char(handles.Data_plot) ' Globaly '...
                                                                          '(' char(handles.average_days) '-day mean)']);
end

guidata(hObject, handles);

% set(handles.list2,'value','1');
% hObject    handle to List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List


% --- Executes during object creation, after setting all properties.
function List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in List2.
function List2_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset

handles.current_state_num = get(handles.List2,'Value');
handles.states = string(get(handles.List2,'String'));

Plotting_Fun(handles);

if strcmpi(handles.states(get(handles.List2,'Value')),"ALL")
          handles.str = handles.countery_Non_Dup(handles.counter_num);          
else
          handles.str = handles.states(get(handles.List2,'Value'));
end
if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = ([char(handles.option) ' Number of ',char(handles.Data_plot),' Globaly (' char(handles.average_days) '-day mean)']);
else 
          handles.axes1.Title.String = ([char(handles.option) ' Number of ',char(handles.Data_plot),' in '...
                              char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end


guidata(hObject, handles);

% hObject    handle to List2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List2


% --- Executes during object creation, after setting all properties.
function List2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)


handles.average_days = get(handles.slider1,'Value');
handles.average_days = char(string(handles.average_days*14 + 1));

if(handles.counter_num~=1)
          handles.str = handles.countery_Non_Dup(handles.counter_num);
          handles.axes1.Title.String = ([char(handles.option) ' Number of ' char(handles.Data_plot) ' in '...
                                        char(handles.countery_Non_Dup(handles.counter_num)) ' (' char(handles.average_days) '-day mean)']);
else
          handles.str = 'Global'; 
          handles.axes1.Title.String = ([char(handles.option) ' Number of ' char(handles.Data_plot) ' Globaly '...
                                                                          '(' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);

% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function value_Callback(hObject, eventdata, handles)
% hObject    handle to value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value as text
%        str2double(get(hObject,'String')) returns contents of value as a double


% --- Executes during object creation, after setting all properties.
function value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cases.
function cases_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset
handles.Data_plot = 'Cases';

Plotting_Fun(handles);


if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = ([char(handles.option) ' Number of Cases Globaly (' char(handles.average_days) '-day mean)']);
else
          handles.axes1.Title.String = ([char(handles.option) ' Number of Cases in ' char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);
% hObject    handle to cases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cases


% --- Executes on button press in deaths.
function deaths_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset
handles.Data_plot = 'Deaths';

Plotting_Fun(handles);

if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = ([char(handles.option) ' Number of Deaths Globaly (' char(handles.average_days) '-day mean)']);
else
          handles.axes1.Title.String = ([char(handles.option) ' Number of Deaths in ' char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);
% hObject    handle to deaths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deaths


% --- Executes on button press in both.
function both_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset
handles.Data_plot = 'Cases & Deaths';

Plotting_Fun(handles);
          
if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = ([char(handles.option) ' Number of Cases & Deaths Globaly (' char(handles.average_days) '-day mean)']);
else
          handles.axes1.Title.String = ([char(handles.option) ' Number of Cases & Deaths in ' char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);
% hObject    handle to both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of both



% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset

handles.option = 'Cumulative';

Plotting_Fun(handles);

if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = (['Cumulative Number of ',char(handles.Data_plot),' Globaly (' char(handles.average_days) '-day mean)']);
else
          handles.axes1.Title.String = (['Cumulative Number of ',char(handles.Data_plot),' in ' char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);

% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in daily.
function daily_Callback(hObject, eventdata, handles)
axes(handles.axes1);
cla reset

handles.option = 'Daily';

Plotting_Fun(handles);

if strcmpi(handles.str,"Global")
          handles.axes1.Title.String = (['Daily Number of ',char(handles.Data_plot),' Globaly (' char(handles.average_days) '-day mean)']);
else
          handles.axes1.Title.String = (['Daily Number of ',char(handles.Data_plot),' in ' char(handles.str) ' (' char(handles.average_days) '-day mean)']);
end
guidata(hObject, handles);

% hObject    handle to daily (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of daily

function uibuttongroup1_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function uibuttongroup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function uibuttongroup1_DeleteFcn(hObject, eventdata, handles)


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
handles.counter_num = 1;
handles.current_countery_num = 1;
handles.str = "Global";
handles.Data_plot = "Cases";
handles.option = "Cumulative";
handles.average_days = '1';
handles.current_state_num = 1;
handles.Daily_Data = 0;
handles.Daily_Data_Deaths = 0;

set(handles.cases,'Value',1);
set(handles.radiobutton4,'Value',1);
set(handles.slider1,'Value',0);
set(handles.List,'Value',1);
set(handles.List2,'Value',1);
set(handles.List2,"String","All");
axes(handles.axes1);
cla reset

Plotting_Fun(handles);
handles.axes1.Title.String = ('Cumulative Number of Cases Globaly (1-day mean)');

guidata(hObject, handles);

% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function varargout = liveData(varargin)
% LIVEDATA MATLAB code for liveData.fig
%      LIVEDATA, by itself, creates a new LIVEDATA or raises the existing
%      singleton*.
%
%      H = LIVEDATA returns the handle to a new LIVEDATA or the handle to
%      the existing singleton*.
%
%      LIVEDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIVEDATA.M with the given input arguments.
%
%      LIVEDATA('Property','Value',...) creates a new LIVEDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before liveData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to liveData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help liveData

% Last Modified by GUIDE v2.5 18-Feb-2016 11:46:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @liveData_OpeningFcn, ...
                   'gui_OutputFcn',  @liveData_OutputFcn, ...
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


% --- Executes just before liveData is made visible.
function liveData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to liveData (see VARARGIN)

% Choose default command line output for liveData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes liveData wait for user response (see UIRESUME)
% uiwait(handles.liveData);

% initialize axis with dummy data
plot(0, 0, '-', 0, 0, 'o', 0, 0, '*');

% update the liste of files in the current directory
updateFilelist(hObject, handles);

% % update the variable lists
T = updateData(hObject, handles);
handles.T = T;
guidata(hObject, handles);

% load list of formulae from formula.mat
load('formula.mat')
set(handles.popupmenuSelectFormula, 'String', F.Name);

% update the plot
updatePlot(handles);

% add select range slider programmatically 
handles.RangeSlider = com.jidesoft.swing.RangeSlider(0,100,0,100);  % min,max,low,high
% get position of axis in px
pos = getpixelposition(handles.axesData);
handles.RangeSlider = javacomponent(handles.RangeSlider, [pos(1),pos(2)+pos(4)-40,pos(3),40], gcf);
set(handles.RangeSlider, 'MajorTickSpacing',25, 'MinorTickSpacing',1, 'PaintTicks',false, 'PaintLabels',false, ...
     'Background',java.awt.Color.white, 'StateChangedCallback',@RangeSlider_Callback);
guidata(hObject, handles);
 
% --- Outputs from this function are returned to the command line.
function varargout = liveData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on range change in RangeSlider.
function RangeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to listboxData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject.lowValue;
hObject.highValue;

% --- Executes on selection change in listboxData.
function listboxData_Callback(hObject, eventdata, handles)
% hObject    handle to listboxData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxData

updateData(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listboxData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenuSelectxValues.
function popupmenuSelectxValues_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectxValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelectxValues contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelectxValues

updatePlot(handles);

% --- Executes during object creation, after setting all properties.
function popupmenuSelectxValues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectxValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSelecty1Values.
function popupmenuSelecty1Values_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelecty1Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelecty1Values contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelecty1Values

updatePlot(handles);

% --- Executes during object creation, after setting all properties.
function popupmenuSelecty1Values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelecty1Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSelecty2Values.
function popupmenuSelecty2Values_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelecty2Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelecty2Values contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelecty2Values
updatePlot(handles);


% --- Executes during object creation, after setting all properties.
function popupmenuSelecty2Values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelecty2Values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editPath_Callback(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPath as text
%        str2double(get(hObject,'String')) returns contents of editPath as a double


% --- Executes during object creation, after setting all properties.
function editPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- sanitize data in order to avoid NaNs and some random text where a
% double is supposed to be!
function dataOut = sanitize(dataIn)
% dataIn    Input data array/cell
% dataOut   Sanitized double array

if isnumeric(dataIn)
    dataOut = dataIn;
elseif iscell(dataIn)
    dataOut = str2double(dataIn);
elseif ischar(dataIn)
    dataOut = str2double(dataIn);
end

% --- updates the measurement data by reloading the selected csv
function T = updateData(hObject, handles)
% hObject    handle to editPath (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% get data path 
dataPath = get(handles.editPath, 'string');
% get name of selected file
fileName = get(handles.listboxData, 'String');
% read table data into T
T = readtable([dataPath '\' fileName{get(handles.listboxData, 'Value')}]);
% append a "None" column
T = [cell2table(cell(size(T,1),1), 'VariableNames',{'None'}) T];
% make table available to the object
handles.T = T;
guidata(hObject, handles);

% populate selection menues for x and y values
set(handles.popupmenuSelectxValues, 'String', T.Properties.VariableNames);
set(handles.popupmenuSelecty1Values, 'String', T.Properties.VariableNames);
set(handles.popupmenuSelecty2Values, 'String', T.Properties.VariableNames);

% update the plot content
updatePlot(handles);

% --- updates the plot with the changed configuration 
function updatePlot(handles)
% handles    structure with handles and user data (see GUIDATA)

% update XData
XData = sanitize(handles.T{:,get(handles.popupmenuSelectxValues, 'Value')});
h = get(handles.axesData);
set(h.Children(1), 'XData', XData);
set(h.Children(2), 'XData', XData);
XLabelText = handles.T.Properties.VariableNames(get(handles.popupmenuSelectxValues, 'Value'));
% sanitize string
XLabelText = strrep(XLabelText, '_', ' ');
set(get(handles.axesData,'XLabel'),'String',XLabelText);

% update Y1Data
Y1Data = sanitize(handles.T{:,get(handles.popupmenuSelecty1Values, 'Value')});
set(h.Children(1), 'YData', Y1Data);
Y1LabelText = handles.T.Properties.VariableNames(get(handles.popupmenuSelecty1Values, 'Value'));
% sanitize string
Y1LabelText = strrep(Y1LabelText, '_', ' ');

% set xdata to a running index if no x data is specified otherwise
if strcmp(XLabelText, 'None')
    XData = 1:numel(Y1Data);
    set(h.Children(1), 'XData', XData);
    set(h.Children(2), 'XData', XData);
end


% update Y2Data
Y2Data = sanitize(handles.T{:,get(handles.popupmenuSelecty2Values, 'Value')});
set(h.Children(2), 'YData', Y2Data);
Y2LabelText = handles.T.Properties.VariableNames(get(handles.popupmenuSelecty2Values, 'Value'));
% sanitize string
Y2LabelText = strrep(Y2LabelText, '_', ' ');

% update X limits
xmin = get(handles.editXMin, 'String');
xmax = get(handles.editXMax, 'String');
set(handles.axesData,'XLim',[str2double(xmin) str2double(xmax)]);

YLabelText = '';
if ~strcmp(Y1LabelText, 'None') && ~strcmp(Y2LabelText, 'None') 
    YLabelText = [char(Y1LabelText), '/', char(Y2LabelText)];
    l = legend(char(Y1LabelText), char(Y2LabelText));
    set(l, 'location', 'best');
elseif ~strcmp(Y1LabelText, 'None')
    YLabelText = Y1LabelText;
    legend('off');
elseif ~strcmp(Y2LabelText, 'None') 
    YLabelText = Y2LabelText;
    legend('off');
end
set(get(handles.axesData,'YLabel'),'String',YLabelText);

% --- updates the current list of files in the specified folder
function updateFilelist(hObject, handles)
% handles    structure with handles and user data (see GUIDATA)

% get data path 
dataPath = get(handles.editPath, 'string');
if exist(dataPath, 'dir')
    % get files in path
    dataList = dir([dataPath '\*.csv']);
    % sort for date of last write 
    [~,sortIndex] = sortrows({dataList.datenum}');
    % populate data selection list
    set(handles.listboxData, 'String', {dataList(flipud(sortIndex)).name});

    T = updateData(hObject, handles);
    handles.T = T;
    guidata(hObject, handles);
else
    errordlg('The selected folder does not exist!');
end

% --- Executes on button press in pushbuttonTodaysFolder.
function pushbuttonTodaysFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTodaysFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set todays data path 
pathToday = ['C:\Experiment\' datestr(now,'YYYYmmDD') ...
    '\Images' datestr(now,'YYYYmmDD')];
set(handles.editPath, 'String', pathToday);
updateFilelist(hObject, handles)

% --- Executes on button press in pushbuttonSelectFolder.
function pushbuttonSelectFolder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pathSelect = uigetdir;
if pathSelect
    set(handles.editPath, 'String', pathSelect);
    updateFilelist(hObject, handles)
end


% --- Executes on button press in togglebuttonMonitorFolder.
function togglebuttonMonitorFolder_Callback(hObject, eventdata, handles)
% hObject    handle to togglebuttonMonitorFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebuttonMonitorFolder
if get(hObject,'Value')
    dataPath = get(handles.editPath, 'String');
    file = System.IO.FileSystemWatcher(dataPath);
    file.InternalBufferSize = 4*4096;
    file.Filter = '*.csv';
    file.EnableRaisingEvents = true;
    addlistener(file,'Changed',@fileChanged);
    addlistener(file,'Deleted',@fileChanged);
    handles.file = file;
    guidata(hObject, handles);
else
    file = handles.file;
    file.EnableRaisingEvents = false;
end

% --- execute an update on the file list and subsequently the data if a
% change in the folder structure was detected by the .NET listener
function fileChanged(source,arg)
handles = guidata(liveData);
updateFilelist(liveData, handles)
updateData(liveData, handles);
if get(handles.togglebuttonContFit, 'Value')
    pushbuttonDoFit_Callback(liveData, 0, handles);
end

% --- Executes on button press in pushbuttonCopyFigure.
function pushbuttonCopyFigure_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCopyFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f1 = figure;
copyobj(handles.axesData,f1);
set(gca, 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8]);
fileName = get(handles.listboxData, 'String');
t = title(gca, fileName{get(handles.listboxData, 'Value')});
set(t, 'Interpreter', 'None');


% --- Executes on button press in pushbuttonSaveToWorkspace.
function pushbuttonSaveToWorkspace_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveToWorkspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = get(handles.axesData);
assignin('base','XData',get(h.Children(1), 'XData'));
assignin('base','Y1Data',get(h.Children(1), 'YData'));
assignin('base','Y2Data',get(h.Children(2), 'YData'));



function editFormula_Callback(hObject, eventdata, handles)
% hObject    handle to editFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFormula as text
%        str2double(get(hObject,'String')) returns contents of editFormula as a double


% --- Executes during object creation, after setting all properties.
function editFormula_CreateFcn(hObject, ~, handles)
% hObject    handle to editFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonDoFit.
function pushbuttonDoFit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDoFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = get(handles.axesData);
XData = get(h.Children(1), 'XData');
Y1Data = get(h.Children(1), 'YData');

[xData, yData] = prepareCurveData( XData, Y1Data );

% Set up fittype and options.
ft = fittype( char(get(handles.editFormula,'String')), 'independent', ...
    'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Robust = 'Bisquare';
% get range slider values

opts.Exclude = xData < max(xData)*handles.RangeSlider.lowValue/100 | ...
    xData > max(xData)*handles.RangeSlider.highValue/100*0.98

% check if startpoints were supplied and the number of starting points
% makes sense. Otherwise print warning in result window
startPoints = str2double(strsplit(get(handles.editStartingPoints, 'String'),','));
if size(startPoints,2) > 0 && size(startPoints,2) == numargs(ft)-1
    opts.StartPoint = startPoints;
elseif size(startPoints,2) > 0
    appendResult(handles, 'Number of Starting Points does not fit the number of free parameters');
end

% Fit model to data.
[f, ~] = fit( xData, yData, ft, opts );

% Plot fit with data.
set(h.Children(3), 'XData', sort(xData));
set(h.Children(3), 'YData', sort(f(xData)));
coeffnms = coeffnames(f);
coeffvals = coeffvalues(f);
ncoeffs = numcoeffs(f);
string = cell(ncoeffs,1);
for i = 1:ncoeffs
    string(i,:) = {[char(coeffnms(i)) ' = ' num2str(coeffvals(i),2)]};
end
appendResult(handles, string);


% --- Appends the resulting string to the result output text field
function appendResult(handles, result)
actualString = flipud(get(handles.textFitResult, 'String'));
actualString{end+1} = char(result);
set(handles.textFitResult, 'String', flipud(actualString));

% --- Executes on button press in togglebuttonContFit.
function togglebuttonContFit_Callback(hObject, eventdata, handles)
% hObject    handle to togglebuttonContFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebuttonContFit



function editStartingPoints_Callback(hObject, eventdata, handles)
% hObject    handle to editStartingPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStartingPoints as text
%        str2double(get(hObject,'String')) returns contents of editStartingPoints as a double


% --- Executes during object creation, after setting all properties.
function editStartingPoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStartingPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSelectFormula.
function popupmenuSelectFormula_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSelectFormula contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSelectFormula

load('formula.mat');
set(handles.editFormula, 'String', char(F.Formula(get(hObject,'Value'))));
set(handles.editStartingPoints, 'String', char(F.InitialValue(get(hObject,'Value'))));

% --- Executes during object creation, after setting all properties.
function popupmenuSelectFormula_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSelectFormula (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXMin_Callback(hObject, eventdata, handles)
% hObject    handle to editXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXMin as text
%        str2double(get(hObject,'String')) returns contents of editXMin as a double
% update X limits
xmin = get(handles.editXMin, 'String');
xmax = get(handles.editXMax, 'String');
set(handles.axesData,'XLim',[str2double(xmin) str2double(xmax)]);

% --- Executes during object creation, after setting all properties.
function editXMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXMax_Callback(hObject, eventdata, handles)
% hObject    handle to editXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXMax as text
%        str2double(get(hObject,'String')) returns contents of editXMax as a double
xmin = get(handles.editXMin, 'String');
xmax = get(handles.editXMax, 'String');
set(handles.axesData,'XLim',[str2double(xmin) str2double(xmax)]);

% --- Executes during object creation, after setting all properties.
function editXMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

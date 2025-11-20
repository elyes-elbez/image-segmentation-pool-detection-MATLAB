function varargout = interface(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


function interface_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);





function varargout = interface_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function [fullname]=pushbutton1_Callback(hObject, eventdata, handles)
[rawname,rawpath]=uigetfile({'*.jpg*'},'Select Image Data');
fullname   =[rawpath rawname];
set(handles.text1,'string',fullname);
I= imread(fullname);
axes(handles.axes1);
imagesc(I);
function text1_CreateFcn(hObject, eventdata, handles)



function pushbutton2_Callback(hObject, eventdata, handles)
path=get(handles.text1,'string');
I= imread(path);
t=size(I);
Ib= I(:,:,3);
Ig= I(:,:,2);
Ir= I(:,:,1);
% choisir la marge de couleur de piscine dans une image et supprime les autre pixels
for i=1:t(1)
    for j=1:t(2)
        if  (Ir(i,j)>190)
            Ir(i,j)=0;
            Ig(i,j)=0;
            Ib(i,j)=0;
        elseif ((Ig(i,j)<80)||(Ig(i,j)>255))
            Ir(i,j)=0;
            Ig(i,j)=0;
            Ib(i,j)=0;
        elseif (Ib(i,j)<165)
               Ir(i,j)=0;
               Ig(i,j)=0;
               Ib(i,j)=0;
        end
    end
end
% transformer l'image RGB on image binair
IMAGE_BLUE=cat(3,Ir,Ig,Ib);
RGB_GRAY=rgb2gray(IMAGE_BLUE);
S=im2bw(RGB_GRAY,0.001);
% supprimer les pixels indesirables
diskElem=strel('disk',1);
Image_clear= imopen(S,diskElem);
% calcul le nombre d'occurence du piscine
hBlobAnalysis=vision.BlobAnalysis('MinimumBlobArea',20,...
    'MaximumBlobArea',5000);
[objArea,objCentroid,bboxOut]=step(hBlobAnalysis,Image_clear);
Ishape=insertShape(I,'rectangle',bboxOut,'linewidth',4);
numObj=numel(objArea);
Text_nombre=vision.TextInserter('%d','Location',[5 5],'Color',...
    [255 255 0],'FontSize',30);
I_nombre= step(Text_nombre,Ishape,int32(numObj));
set(handles.text8,'string',numObj);

function pushbutton3_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

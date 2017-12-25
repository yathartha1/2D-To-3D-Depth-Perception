function varargout = untitled(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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




function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Cpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.Image1,'reset');
cla(handles.Image2,'reset');
cla(handles.Output,'reset');



function Spushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Spushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1;
[fname,path]=uigetfile('*.png','Select an Image');
fname=strcat(path,fname);
im1=imread(fname);
axes(handles.Image1);
imshow(im1);


function Spushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to Spushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imlabled;
[lfname,path1]=uigetfile('*.png','Select a labeled image');
lfname=strcat(path1,lfname);
imlabled=imread(lfname);
axes(handles.Image2);
imshow(imlabled);


function Spushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to Spushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1;
global imlabled;
global r1;
global r2;
im=double(im1)/255;
hsvImage = rgb2hsv(imlabled);
h = hsvImage(:,:, 1);
s = hsvImage(:,:, 2);
v = hsvImage(:,:, 3);
mask = v < 0.7;
h(mask) = 1;
s(mask) = 1;
v(mask) = 0;
hsvImage = cat(3, h, s, v);
newlRGB = hsv2rgb(hsvImage);
newlRGB=rgb2gray(newlRGB);

rmat=imlabled(:,:,1);
gmat=imlabled(:,:,2);
bmat=imlabled(:,:,3);

redthreshold=70;
greenthreshold=65;
bluethreshold=65;
redmask=(rmat>redthreshold);
greenmask=(gmat<greenthreshold);
bluemask=(bmat<bluethreshold);
redobmask=redmask&greenmask&bluemask;
redobmask=uint8(redobmask);
masked=uint8(zeros(size(redobmask)));
masked(:,:,1) = imlabled(:,:,1) .* redobmask;
masked(:,:,2) = imlabled(:,:,2) .* redobmask;
masked(:,:,3) = imlabled(:,:,3) .* redobmask;
masked1=rgb2gray(masked);
mask=im2bw(masked1,0);
seeds=find(mask==1);

alpha=100;
beta=10000;


[m,n,d]=size(im);
im=rgb2lab(im);
[node,edge]=creategraph(m,n);
W=calcweight(edge,reshape(im,m*n,d),m,n,alpha);
if(r2==1)
    A=KDTree(im,m,n,d,alpha,beta);
else if(r1==1)
    A=KNN(im,m,n,d,alpha,beta);
    end;
end;
A=A+(10*W);
Diag=spdiags(sum(A,2),0,n*m,n*m);
laplace=Diag-A;
boundary=newlRGB(seeds);
prob = dirichlet(laplace,seeds(:),boundary);
prob = reshape(prob, m, n);
depth = uint8(prob.*255);
axes(handles.Output);
imshow(depth);




function Apushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to Apushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
[fname,path]=uigetfile('*.png','Select an Image');
fname=strcat(path,fname);
im=imread(fname);
axes(handles.Image1);
imshow(im);



function Apushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to Apushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global result;
red=im(:,:,1);
green=im(:,:,2);
blue=im(:,:,3);

red=0.299.*red+0.587.*green+0.114.*blue;
green=0.492.*(blue-green);
blue=0.877.*(red-green);
Y=red;
U=green;
V=blue;
im(:,:,1)=Y;
im(:,:,2)=U;
im(:,:,3)=V;

[appry,hory,very,diagy]=dwt2(Y,'db2');
[appru,horu,veru,diagu]=dwt2(U,'db2');
[apprv,horv,verv,diagv]=dwt2(V,'db2');
appr(:,:,1)=appry;appr(:,:,2)=appru;appr(:,:,3)=apprv;
hor(:,:,1)=hory;hor(:,:,2)=horu;hor(:,:,3)=horv;
ver(:,:,1)=very;ver(:,:,2)=veru;ver(:,:,3)=verv;
diag(:,:,1)=diagy;diag(:,:,2)=diagu;diag(:,:,3)=diagv;

[appr1y,hor1y,ver1y,diag1y]=dwt2(appr(:,:,1),'db2');
[appr1u,hor1u,ver1u,diag1u]=dwt2(appr(:,:,2),'db2');
[appr1v,hor1v,ver1v,diag1v]=dwt2(appr(:,:,3),'db2');
appr1(:,:,1)=appr1y;appr1(:,:,2)=appr1u;appr1(:,:,3)=appr1v;
hor1(:,:,1)=hor1y;hor1(:,:,2)=hor1u;hor1(:,:,3)=hor1v;
ver1(:,:,1)=ver1y;ver1(:,:,2)=ver1u;ver1(:,:,3)=ver1v;
diag1(:,:,1)=diag1y;diag1(:,:,2)=diag1u;diag1(:,:,3)=diag1v;
result=hor1+ver1+diag1;
axes(handles.Image2);
imshow(result);



function Apushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to Apushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global result;
[h,w,n]=size(result);
T=zeros(h,w,'uint8');
   for i=1:h
       for j=1:w
           val=result(i,j);
           if val<25
               T(i,j)=0;
           else
               T(i,j)=255;
           end;
       end;
   end;
h1=ones(3,3)/9;
F=imfilter(T,h1);
V=zeros(h,w,'uint8');
       for i=1:h
           for j=1:w
               val=F(i,j);
               if val<30
                    V(i,j)=0;
               else
                    V(i,j)=255;
               end;
           end;
       end;
axes(handles.Output);
imshow(V);



function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global r1;
global r2;
r1=get(handles.radiobutton1,'Value');
r2=get(handles.radiobutton2,'Value');

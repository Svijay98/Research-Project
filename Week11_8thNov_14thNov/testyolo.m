v = VideoReader('person01_handwaving_d1_uncomp.avi');
tic
if exist('yoloml') ~= 1
    display('loading modified network')
    s = load('yoloml.mat')
    %save yoloml     
end
toc


while hasFrame(v)
    image = readFrame(v);
    bbox = yolo_fun(image,s.yoloml)
%     image = insertObjectAnnotation(image,'rectangle',bbox,"single bounding box");
%     imshow(image)
end
    

function single_bbox = yolo_fun(image,yoloml)


probThresh = 0.08;
iouThresh = 0.1;   
        
image = single(imresize(image,[448 448]))/255;
classLabels = ["aeroplane",	"bicycle",	"bird"	,"boat",	"bottle"	,"bus"	,"car",...
    "cat",	"chair"	,"cow"	,"diningtable"	,"dog"	,"horse",	"motorbike",	"person",	"pottedplant",...
    "sheep",	"sofa",	"train",	"tvmonitor"];

out = predict(yoloml,image,'ExecutionEnvironment','gpu');

probThresh = 0.10;


class = out(1:980);
boxProbs = out(981:1078);
boxDims = out(1079:1470);

outArray = zeros(7,7,30);
for j = 0:6
    for i = 0:6
        outArray(i+1,j+1,1:20) = class(i*20*7+j*20+1:i*20*7+j*20+20);
        outArray(i+1,j+1,21:22) = boxProbs(i*2*7+j*2+1:i*2*7+j*2+2);
        outArray(i+1,j+1,23:30) = boxDims(i*8*7+j*8+1:i*8*7+j*8+8);
    end
end

[cellProb, cellIndex] = max(outArray(:,:,21:22),[],3);
contain = max(outArray(:,:,21:22),[],3)>probThresh;


[classMax,classMaxIndex] = max(outArray(:,:,1:20),[],3);

counter = 0;
for i = 1:7
    for j = 1:7
        if contain(i,j) == 1
            counter = counter+1;
            
            x = outArray(i,j,22+1+(cellIndex(i,j)-1)*4);
            y = outArray(i,j,22+2+(cellIndex(i,j)-1)*4);
            
            w = (outArray(i,j,22+3+(cellIndex(i,j)-1)*4))^2;
            h = (outArray(i,j,22+4+(cellIndex(i,j)-1)*4))^2;
            
            %absolute values scaled to image size
            %                     wS = w*448;
            %                     hS = h*448;
            %                     xS = (j-1)*448/7+x*448/7-wS/2;
            %                     yS = (i-1)*448/7+y*448/7-hS/2;
            
            wS = w*448*1.5;
            hS = h*448*1.3;
            xS = ((j-1)*448/7+x*448/7-wS/2);
            yS = ((i-1)*448/7+y*448/7-hS/2);
            
            
            
            
            % this array will be used for drawing bounding boxes in Matlab
            boxes(counter).coords = [xS yS wS hS];
            
            %save cell indices in the structure
            boxes(counter).cellIndex = [i,j];
            
            %save classIndex to structure
            boxes(counter).classIndex = classMaxIndex(i,j);
            
            % save cell proability to structure
            boxes(counter).cellProb = cellProb(i,j);
            
            % put in a switch for non max which we will use later
            boxes(counter).nonMax = 1;
        end
    end
end

if exist('boxes')
    nonIntersectBoxes = yoloIntersect(classLabels, boxes,image);
    l = zeros(5,20);
    for i =1:length(nonIntersectBoxes)
        l(1:4,i) = nonIntersectBoxes(i).coords ;
        l(5,i) = i;
    end
    l = l(:,1:i);
    max_width = max(l(3,:));
    max_height = max(l(4,:));
    min_x = min(l(1,:));
    min_y = min(l(2,:));
    image = insertObjectAnnotation(image,'rectangle',[min_x min_y max_width max_height],"single bounding box");
    imshow(image)
    single_bbox = [min_x min_y max_width max_height];
end
clear boxes

end
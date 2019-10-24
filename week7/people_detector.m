clc;
clear all;

v = VideoReader('images+videos/person05_handwaving_d2_uncomp.avi');
cnt =  0;
frame_no = 0;
frame = 0;
while hasFrame(v)
    frame_no =  frame_no + 1;
    img = readFrame(v);
    frame = frame + 1;
    peopleDetector = vision.PeopleDetector('ClassificationModel','UprightPeople_96x48');
    %img = imresize(img,[256 256]);
    img = rgb2gray(img);
    %imshow(img);
    [bboxes,scores] =  peopleDetector(img);
    if isempty(bboxes)
        disp(frame);
        imshow(img);
    end
    if ~isempty(bboxes)
         bboxes(1) = bboxes(1) / 1.5;
%         bboxes(2) = bboxes(2) / 5;
         bboxes(3) = bboxes(3) * 2;
         if (bboxes(1) + bboxes(3)) > 160 
             bboxes(3) = 160 - bboxes(1);
         end
%         bboxes(4) = bboxes(4) * 1.5;
        I = insertObjectAnnotation(img,'rectangle',bboxes(1,:),scores(1));
        imshow(I);
        features = detectHarrisFeatures(img,'ROI',bboxes(1,:));
        img = insertMarker(img,features.Location);
        imshow(img);
        if(frame_no >= 15)
            cnt = cnt + features.length;
            frame_no = 0;
        end
        
    end
end



clc;
%v = VideoReader('D:\Research Project\Matlab\KTH_dataset\handwaving\person01_handwaving_d1_uncomp.avi');
v = VideoReader('traffic.mp4');
t = 1./v.FrameRate
frame1 = readFrame(v);
prev_points = detectMinEigenFeatures(rgb2gray(frame1));
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,prev_points.Location,rgb2gray(frame1));
i = 3;
while hasFrame(v)
    frame = readFrame(v);
    frame = rgb2gray(frame);
    [curr_points,validity] = tracker(frame);
    out = insertMarker(frame,points,'+');
    imshow(out);
    i = i - 1;
end
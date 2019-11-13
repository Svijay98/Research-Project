clc;
v = VideoReader('D:\Research Project\Matlab\KTH_dataset\handwaving\person01_handwaving_d1_uncomp.avi');
%v = VideoReader('D:\Research Project\Matlab\KTH_dataset\running\person02_running_d1_uncomp.avi');
%v = VideoReader('traffic.mp4');
prev_frame = readFrame(v);
prev_frame = rgb2gray(prev_frame);
prev_frame = imresize(prev_frame, [256 256]);
prev_features = detectMinEigenFeatures(prev_frame);
tracker = vision.PointTracker();
initialize(tracker,prev_features.Location,prev_frame);
prev_points = prev_features.Location;
while hasFrame(v)
    curr_frame = readFrame(v);
    curr_frame = rgb2gray(curr_frame);
    curr_frame = imresize(curr_frame, [256 256]);
    [curr_points,validity] = tracker(curr_frame);
    ax = axes;
    showMatchedFeatures(prev_frame,curr_frame,prev_points,curr_points,'PlotOptions',{'.','.','y-'});
    prev_points = curr_points;
    prev_frame = curr_frame;
    i = i - 1;
end


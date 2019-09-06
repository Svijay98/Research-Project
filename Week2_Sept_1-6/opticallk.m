vidReader = VideoReader('visiontraffic.avi','CurrentTime',11); %Read a video file. Specify the timestamp of the frame to be read.
opticFlow = opticalFlowLK; %Create an optical flow object for estimating the optical flow using Lucas-Kanade method. 
h = figure; %create figure window
movegui(h); % moves the figure to the closest position that puts it entirely on screen.
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');%create panel in the current figure
hPlot = axes(hViewPanel); %create cartseian axes
while hasFrame(vidReader) %Determine if frame is available to read
    frameRGB = readFrame(vidReader); %Read video frame from video file
    frameGray = rgb2gray(frameRGB); %Convert to gray scale images
    flow = estimateFlow(opticFlow,frameGray); %estimate optical flow
    imshow(frameRGB)%Display image
    hold on %Retain current plot when adding new plots
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10,'Parent',hPlot); %2-D line plot
    hold off %new plots added to the axes clear existing plots and reset all axes properties
    pause(10^-3) % pauses execution for 10^-3 seconds before continuing.
end
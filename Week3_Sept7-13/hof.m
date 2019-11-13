clc;
vidReader = VideoReader('visiontraffic.avi','CurrentTime',12); %Read a video file. Specify the timestamp of the frame to be read.
opticFlow = opticalFlowLK; %Create an optical flow object for estimating the optical flow using Lucas-Kanade method. 
frameRGB = readFrame(vidReader); %Read video frame from video file
frameGray = rgb2gray(frameRGB); %Convert to gray scale images
%imshow(frameRGB);
flow = estimateFlow(opticFlow,frameGray); %estimate optical flow
bin = zeros(1,9);
for r=1:(size(flow.Orientation,1))/16
         for c=1:(size(flow.Orientation,2))/16 
                  k=abs(rad2deg(flow.Orientation(r,c)));
                  if k>10 && k<=30
                            bin(1)=bin(1)+ flow.Magnitude(r,c)*(30-k)/20;
                            bin(2)=bin(2)+ flow.Magnitude(r,c)*(k-10)/20;
                  elseif k>30 && k<=50
                            bin(2)=bin(2)+ flow.Magnitude(r,c)*(50-k)/20;                 
                            bin(3)=bin(3)+ flow.Magnitude(r,c)*(k-30)/20;
                  elseif k>50 && k<=70
                            bin(3)=bin(3)+ flow.Magnitude(r,c)*(70-k)/20;
                            bin(4)=bin(4)+ flow.Magnitude(r,c)*(k-50)/20;
                  elseif k>70 && k<=90
                            bin(4)=bin(4)+ flow.Magnitude(r,c)*(90-k)/20;
                            bin(5)=bin(5)+ flow.Magnitude(r,c)*(k-70)/20;
                  elseif k>90 && k<=110
                            bin(5)=bin(5)+ flow.Magnitude(r,c)*(110-k)/20;
                            bin(6)=bin(6)+ flow.Magnitude(r,c)*(k-90)/20;
                  elseif k>110 && k<=130
                            bin(6)=bin(6)+ flow.Magnitude(r,c)*(130-k)/20;
                            bin(7)=bin(7)+ flow.Magnitude(r,c)*(k-110)/20;
                  elseif k>130 && k<=150
                            bin(7)=bin(7)+ flow.Magnitude(r,c)*(150-k)/20;
                            bin(8)=bin(8)+ flow.Magnitude(r,c)*(k-130)/20;
                  elseif k>150 && k<=170
                            bin(8)=bin(8)+ flow.Magnitude(r,c)*(170-k)/20;
                            bin(9)=bin(9)+ flow.Magnitude(r,c)*(k-150)/20;
                  elseif k>=0 && k<=10
                            bin(1)=bin(1)+ flow.Magnitude(r,c)*(k+10)/20;
                            bin(9)=bin(9)+ flow.Magnitude(r,c)*(10-k)/20;
                  elseif k>170 && k<=180
                            bin(9)=bin(9)+ flow.Magnitude(r,c)*(190-k)/20;
                            bin(1)=bin(1)+ flow.Magnitude(r,c)*(k-170)/20;
                  end
                        
         end
end
stem(bin);

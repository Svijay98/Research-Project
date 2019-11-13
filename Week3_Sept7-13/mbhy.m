clc;
vidReader = VideoReader('visiontraffic.avi','CurrentTime',12); %Read a video file. Specify the timestamp of the frame to be read.
opticFlow = opticalFlowLK; %Create an optical flow object for estimating the optical flow using Lucas-vanade method. 
frameRGB = readFrame(vidReader); %Read video frame from video file
frameGray = rgb2gray(frameRGB); %Convert to gray scale images
%imshow(frameRGB);
flow = estimateFlow(opticFlow,frameGray); %estimate optical flow
bin = zeros(1,8);
[Vyx,Vyy] = imgradientxy(flow.Vy);
[m,o] = imgradient(Vyx,Vyy);
%m=sqrt(Vxx(r,c)^2+Vxy(r,c)^2);
%o=atan2(Vxy(r,c),Vxx(r,c))
for r=1:size(m,1)/16
      for c=1:size(m,2)/16
             v=abs(o(r,c));
             if v>11.25 && v<=33.75
                    bin(1)=bin(1)+ m(r,c)*(33.75-v)/22.5;
                    bin(2)=bin(2)+ m(r,c)*(v-11.25)/22.5;
             elseif v>33.75 && v<=56.25
                    bin(2)=bin(2)+ m(r,c)*(56.25-v)/22.5;                 
                    bin(3)=bin(3)+ m(r,c)*(v-33.75)/22.5;
             elseif v>56.25 && v<=78.75
                    bin(3)=bin(3)+ m(r,c)*(78.75-v)/22.5;
                    bin(4)=bin(4)+ m(r,c)*(v-56.25)/22.5;
             elseif v>78.75 && v<=101.25
                    bin(4)=bin(4)+ m(r,c)*(101.25-v)/22.5;
                    bin(5)=bin(5)+ m(r,c)*(v-78.75)/22.5;
             elseif v>101.25 && v<=123.75
                    bin(5)=bin(5)+ m(r,c)*(123.75-v)/22.5;
                    bin(6)=bin(6)+ m(r,c)*(v-101.25)/22.5;
             elseif v>123.75 && v<=146.25
                    bin(6)=bin(6)+ m(r,c)*(146.25-v)/22.5;
                    bin(7)=bin(7)+ m(r,c)*(v-123.75)/22.5;
             elseif v>146.25 && v<=168.75
                    bin(7)=bin(7)+ m(r,c)*(168.75-v)/22.5;
                    bin(8)=bin(8)+ m(r,c)*(v-146.25)/22.5;
             elseif v>=0 && v<=11.25
                    bin(1)=bin(1)+ m(r,c)*(v+10)/22.5;
                    bin(8)=bin(8)+ m(r,c)*(10-v)/22.5;
             elseif v>168.75 && v<=180
                    bin(8)=bin(8)+ m(r,c)*(191.25-v)/22.5;
                    bin(1)=bin(1)+ m(r,c)*(v-168.75)/22.5;
             end
                        
      end
end
stem(bin);
figure;
quiver(Vyx,Vyy);

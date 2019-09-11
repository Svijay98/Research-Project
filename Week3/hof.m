clc;
vidReader = VideoReader('visiontraffic.avi','CurrentTime',11); %Read a video file. Specify the timestamp of the frame to be read.
opticFlow = opticalFlowLK; %Create an optical flow object for estimating the optical flow using Lucas-Kanade method. 
frameRGB = readFrame(vidReader); %Read video frame from video file
frameGray = rgb2gray(frameRGB); %Convert to gray scale images
flow = estimateFlow(opticFlow,frameGray); %estimate optical flow
bin = zeros(1,9);
cnt = 0;
for r=1:(size(flow.Orientation,1))/16
         for c=1:(size(flow.Orientation,2))/16 
            tic
            disp(cnt);
            if(flow.Orientation(r,c)<0)
                k=360-rad2deg(abs(flow.Orientation(r,c)));
            else
                k=rad2deg(flow.Orientation(r,c));
            end
            if (k>=0)&&(k<=40);
                l1=k-20;
                l2=k-340;
                l3=k-60;
                l=l1+l2;
                t=l1+l3;
                if(k<=20);
                    bin(1)=bin(1)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(9)=bin(9)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>20);
                    bin(1)=bin(1)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(2)=bin(2)+flow.Magnitude(r,c)*abs(l1/t);
                end
            elseif(k>=41)&&(k<=80);
                l1=k-20;
                l2=k-60;
                l3=k-100;
                l=l1+l2;
                t=l1+l3;
                if(k<=60);
                    bin(1)=bin(1)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(2)=bin(2)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>60);
                    bin(2)=bin(2)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(3)=bin(3)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=81)&&( k<=120);
                l1=k-60;
                l2=k-100;
                l3=k-140;
                l=l1+l2;
                t=l1+l3;
                if(k<=100);
                    bin(2)=bin(2)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(3)=bin(3)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>100);
                    bin(3)=bin(3)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(4)=bin(4)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=121)&&(k<=160);
                l1=k-100;
                l2=k-140;
                l3=k-180;
                l=l1+l2;
                t=l1+l3;
                if(k<=140);
                    bin(3)=bin(3)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(4)=bin(4)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>140);
                    bin(4)=bin(4)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(5)=bin(5)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=161)&& (k<=200);
                l1=k-140;
                l2=k-180;
                l3=k-220;
                l=l1+l2;
                t=l1+l3;
                if(k<=180);
                    bin(4)=bin(4)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(5)=bin(5)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>180);
                    bin(5)=bin(5)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(6)=bin(6)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=201)&& abs(k<=240);
                l1=k-180;
                l2=k-220;
                l3=k-260;
                l=l1+l2;
                t=l1+l3;
                if(k<=220);
                    bin(5)=bin(5)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(6)=bin(6)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>220);
                    bin(6)=bin(6)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(7)=bin(7)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=241)&&(k<=280);
                l1=k-220;
                l2=k-260;
                l3=k-300;
                l=l1+l2;
                t=l1+l3;
                if(k<=260);
                    bin(6)=bin(6)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(7)=bin(7)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>260);
                    bin(7)=bin(7)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(8)=bin(8)+flow.Magnitude(r,c)*abs(l2/t);
                end
            elseif(k>=281)&&(k<=320);
                l1=k-260;
                l2=k-300;
                l3=k-340;
                l=l1+l2;
                t=l1+l3;
                if(k<=300);
                    bin(8)=bin(8)+flow.Magnitude(r,c)*abs(l1/l);
                    bin(7)=bin(7)+flow.Magnitude(r,c)*abs(l2/l);
                else(k>300);
                    bin(8)=bin(8)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(9)=bin(9)+flow.Magnitude(r,c)*abs(l2/t);
                end
            else(k>=321)&&(k<=360)
                l1=k-300;
                l2=k-340;
                l3=k-20;
                l=l1+l2;
                t=l1+l3;
                if(k<=340);
                    bin(8)=bin(8)+flow.Magnitude(r,c)*abs(l2/l);
                    bin(9)=bin(9)+flow.Magnitude(r,c)*abs(l1/l);
                else(k>340);
                    bin(9)=bin(9)+flow.Magnitude(r,c)*abs(l3/t);
                    bin(1)=bin(1)+flow.Magnitude(r,c)*abs(l2/t);
                end
            end
            cnt = cnt + 1;
            toc
         end
end
edges = linspace(0, 360, 9);
histogram(bin, 'BinEdges',edges);
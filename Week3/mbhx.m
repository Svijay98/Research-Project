clc;
vidReader = VideoReader('visiontraffic.avi','CurrentTime',11); %Read a video file. Specify the timestamp of the frame to be read.
opticFlow = opticalFlowLK; %Create an optical flow object for estimating the optical flow using Lucas-Kanade method. 
frameRGB = readFrame(vidReader); %Read video frame from video file
frameGray = rgb2gray(frameRGB); %Convert to gray scale images
flow = estimateFlow(opticFlow,frameGray); %estimate optical flow
bin = zeros(1,8);
Vxx = zeros(1,1);
Vxy = zeros(1,1);
for r=1:(size(flow.Vx,1))/8
         for c=1:(size(flow.Vx,2))/8 
             [Vxx,Vxy] = imgradientxy(flow.Vx(r,c));
             [m,o] = imgradient(Vxx,Vxy);
             %m=sqrt(Vxx^2+Vxy^2);
             %o=atan2(Vxy,Vxx);
            o=rad2deg(o);
             if(o<0)
                k=360-o;
            else
                k=o;
             end
            if (k>=0)&&(k<=45);
                l1=k-22.5;
                l2=k-337.5;
                l3=k-67.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=22.5);
                    bin(1)=bin(1)+m*abs(l2/l);
                    bin(8)=bin(8)+m*abs(l1/l);
                else(k>22.5);
                    bin(1)=bin(1)+m*abs(l3/t);
                    bin(2)=bin(2)+m*abs(l1/t);
                end
            elseif(k>=46)&&(k<=90);
                l1=k-22.5;
                l2=k-67.5;
                l3=k-112.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=67.5);
                    bin(1)=bin(1)+m*abs(l2/l);
                    bin(2)=bin(2)+m*abs(l1/l);
                else(k>67.5);
                    bin(2)=bin(2)+m*abs(l3/t);
                    bin(3)=bin(3)+m*abs(l2/t);
                end
            elseif(k>=91)&&(k<=135);
                l1=k-67.5;
                l2=k-112.5;
                l3=k-157.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=112.5);
                    bin(2)=bin(2)+m*abs(l2/l);
                    bin(3)=bin(3)+m*abs(l1/l);
                else(k>112.5);
                    bin(3)=bin(3)+m*abs(l3/t);
                    bin(4)=bin(4)+m*abs(l2/t);
                end
            elseif(k>=136)&&(k<=180);
                l1=k-112.5;
                l2=k-157.5;
                l3=k-202.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=157.5);
                    bin(3)=bin(3)+m*abs(l2/l);
                    bin(4)=bin(4)+m*abs(l1/l);
                else(k>157.5);
                    bin(4)=bin(4)+m*abs(l3/t);
                    bin(5)=bin(5)+m*abs(l2/t);
                end
            elseif(k>=181)&& (k<=225);
                l1=k-157.5;
                l2=k-202.5;
                l3=k-247.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=202.5);
                    bin(4)=bin(4)+m*abs(l2/l);
                    bin(5)=bin(5)+m*abs(l1/l);
                else(k>202.5);
                    bin(5)=bin(5)+m*abs(l3/t);
                    bin(6)=bin(6)+m*abs(l2/t);
                end
            elseif(k>=226)&& abs(k<=270);
                l1=k-202.5;
                l2=k-247.5;
                l3=k-292.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=247.5);
                    bin(5)=bin(5)+m*abs(l2/l);
                    bin(6)=bin(6)+m*abs(l1/l);
                else(k>247.5);
                    bin(6)=bin(6)+m*abs(l3/t);
                    bin(7)=bin(7)+m*abs(l2/t);
                end
            elseif(k>=271)&&(k<=315);
                l1=k-247.5;
                l2=k-292.5;
                l3=k-337.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=292.5);
                    bin(6)=bin(6)+m*abs(l2/l);
                    bin(7)=bin(7)+m*abs(l1/l);
                else(k>292.5);
                    bin(7)=bin(7)+m*abs(l3/t);
                    bin(8)=bin(8)+m*abs(l2/t);
                end
            else(k>=316)&&(k<=360);
                l1=k-337.5;
                l2=k-22.5;
                l3=k-292.5;
                l=l1+l2;
                t=l1+l3;
                if(k<=337.5);
                    bin(8)=bin(8)+m*abs(l3/l);
                    bin(7)=bin(7)+m*abs(l1/l);
                else(k>337.5);
                    bin(8)=bin(8)+m*abs(l2/t);
                    bin(1)=bin(1)+m*abs(l1/t);
                end  
            end
             
         end
end

edges = linspace(0, 360, 8); 
histogram(bin, 'BinEdges',edges);
            
            

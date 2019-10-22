function lbp = testcslbp(cuboid)
    lbp=zeros(1024,1);
    for t=1:5
        [x y]=size(cuboid);
        for i=2:x-1
            for j=2:y-1
                a = (((cuboid(i,j) - cuboid(i, j+1)) ) * 2^0 );  
                b = (((cuboid(i,j) - cuboid(i+1, j+1)) ) * 2^1 ); 
                c = (((cuboid(i,j) - cuboid(i+1, j)) ) * 2^2 ); 
                d = (((cuboid(i,j) - cuboid(i+1, j-1))  ) * 2^3 );
                e = (((cuboid(i,j) - cuboid(i, j-1))  ) * 2^4 );
                f = (((cuboid(i,j) - cuboid(i-1, j-1))  ) * 2^5 );
                g = (((cuboid(i,j) - cuboid(i-1, j))  ) * 2^6 ); 
                h = (((cuboid(i,j) - cuboid(i-1, j+1))  ) * 2^7 ); 
                k=a+b+c+d+e+f+g+h;
                lbp(k+1) = lbp(k+1) + 1;
            end
        end 
    end
end

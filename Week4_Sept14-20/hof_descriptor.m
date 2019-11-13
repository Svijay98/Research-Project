function descriptor = hof_descriptor(cuboid)
    descriptor = [];
    for x = 1:16:32
        for y = 1:16:32
            for t = 1:5:15
                bin = hof(cuboid(x:x+15,y:y+15,t:t+4));
            descriptor = cat(2,descriptor,bin);
            end
        end
    end
end
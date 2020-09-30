function [x_list,y_list]=areaScanPreview(axes,area_height,area_width,sensor_height,...
    sensor_width,f_tube,f_obj,mag_obj,overlap,nrows_field,ncols_field,...
    nimages_field)

overlap=overlap/100;

total_mag = mag_obj * (f_tube / f_obj);
image_height = sensor_height / total_mag;
image_width = sensor_width / total_mag;

n_rows = ceil(area_height/(image_height*(1-overlap)));
n_cols = ceil(area_width/(image_width*(1-overlap)));

x_0 = (image_width/2)-(image_width*overlap);
x_end = (area_width-(image_width/2))+(image_width*overlap);
y_0 = (image_height/2)-(image_height*overlap);
y_end = (area_height-(image_height/2))+(image_height*overlap);

xs = linspace(x_0,x_end,n_cols);
ys = linspace(y_0,y_end,n_rows);

[x_list,y_list] = meshgrid(xs,ys);

for i=1:numel(axes.Children)
    delete(axes.Children(1))
end
area_position = [150-area_width/2, 150-area_height/2,...
    area_width, area_height];
rectangle(axes,'Position',area_position)

edgecolors = [228,26,28
55,126,184
77,175,74
152,78,163
255,127,0]/255;

alpha=0.7;
fillcolors = [228,26,28,alpha
55,126,184,alpha
77,175,74,alpha
152,78,163,alpha
255,127,0,alpha]/255;

for i=1:numel(x_list)
    frame_position = [area_position(1)+x_list(i)-image_width/2,...
        area_position(2)+y_list(i)-image_height/2,...
        image_width, image_height];
    rectangle(axes,'Position',frame_position,...
        'EdgeColor',edgecolors(mod(i,length(edgecolors))+1,:),...
        'FaceColor',fillcolors(mod(i,length(fillcolors))+1,:),...
        'LineStyle','-.');
end

nrows_field.Value = n_rows;
ncols_field.Value = n_cols;
nimages_field.Value = n_rows * n_cols;

end
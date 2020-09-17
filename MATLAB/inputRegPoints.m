function registration_points = inputRegPoints
% Prompt user for row/column address of registration points
correct = false;
while ~correct
    prompt = {['Enter row/column address of registration points in',...
        ' the following format: "x_1,y_1; x_2,y_2; x_3,y_3"']};
    regpts_str = inputdlg(prompt);
    regpts_split = strsplit(regpts_str{1},';');
    for i=1:3
        pair = strsplit(regpts_split{i},',');
        registration_points(i,1) = str2double(pair{1});
        registration_points(i,2) = str2double(pair{2});
    end
    verify = questdlg(sprintf(['Is this correct? \n (x,y) \n',...
        num2str(registration_points(1,1)),',',...
        num2str(registration_points(1,2)),'\n',...
        num2str(registration_points(2,1)),',',...
        num2str(registration_points(2,2)),'\n',...
        num2str(registration_points(3,1)),',',...
        num2str(registration_points(3,2))]),...
        'Verify points','Yes','No','Yes');
    switch verify
        case 'Yes'
            correct = true;
        case 'No'
            correct = false;
    end
end
end


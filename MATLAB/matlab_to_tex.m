% This script generates a tex file that can be dropped into the Scanning
% Imager Guide to neatly and easily include the MATLAB code.

filelist = dir('*.m');

for i=1:numel(filelist)
    texname = [filelist(i).name(1:end-1),'tex'];
    fin = fopen(filelist(i).name,'r');
    fout = fopen(['matlab_tex_files\',texname],'w');
    A = fscanf(fin,'%c');
    fprintf(fout,'%c','\begin{lstlisting}');
    fprintf(fout,'\n');
    fprintf(fout,'%c',A);
    fprintf(fout,'\n');
    fprintf(fout,'%c','\end{lstlisting}');
    fclose(fin);
    fclose(fout);
end

mastername = 'matlab_functions.tex';
texwrite = fopen(mastername,'w');
for i=1:numel(filelist)
    if ~or(strcmp(filelist(i).name,'matlab_to_tex.m'),strcmp(filelist(i).name,'MAIN.m'))
        firstline = ['\subsubsection{',filelist(i).name(1:end-2),'}'];
        secondline = ['\input{matlab_tex_files/',filelist(i).name(1:end-2),'}'];
        fprintf(texwrite,'%c',firstline);
        fprintf(texwrite,'\n');
        fprintf(texwrite,'%c',secondline);
        fprintf(texwrite,'\n');
    end
end
fclose(texwrite);

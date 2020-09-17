filelist = dir('*.m');

for i=1:numel(filelist)
    texname = [filelist(i).name(1:end-1),'tex'];
    fin = fopen(filelist(i).name,'r');
    fout = fopen(['..\ScanningImager_guide\matlab_files\',texname],'w');
    A = fscanf(fin,'%c');
    fprintf(fout,'%c','\begin{lstlisting}');
    fprintf(fout,'\n');
    fprintf(fout,'%c',A);
    fprintf(fout,'\n');
    fprintf(fout,'%c','\end{lstlisting}');
    fclose(fin);
    fclose(fout);
end
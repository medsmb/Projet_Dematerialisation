% récupération des fichiers png
pwddir = fullfile('Factures','*.png');
D = dir(pwddir);
chemin = strcat(D(1).folder,'\');
nbImg = size(D,1);
disp(nbImg);

fid = fopen('Factures/factures.csv', 'a');

fprintf(fid, 'Nom_image;Désignation;Numéro_facture;Date;Montant\n');

zone_recherche = [5 5 1250 1220];

zones{1,1} = [1575 55 325 55];
zones{2,1} = [1795 295 275 45];
zones{3,1} = [2100 3040 230 60];

zones{1,2} = [150 1125 145 55];
zones{2,2} = [495 1125 170 55];
zones{3,2} = [2145 2870 170 60];

zones{1,3} = [1250 330 195 60];
zones{2,3} = [2040 330 195 60];
zones{3,3} = [2100 3205 140 55];

item = cell(3);

for n=1:1:nbImg
    info = ['-- lecture de l image ',num2str(n),'/',num2str(nbImg),' --'];
    disp(info);
    fic = strcat(chemin,D(n).name);
    img = imread(fic);
    disp('-- calcul du seuil et binarisation --');
    seuil = graythresh(img);
    imgNB = im2bw(img, seuil);
    disp('-- calcul ocr --');
    ocrResults = ocr(imgNB, zone_recherche);
    texteReconnu = upper(ocrResults.Text);
    disp('-- recherches des infos --');
    
    if isempty(strfind(texteReconnu, 'MOREY')) == 0
        fact = 2;
        nom = 'MOREY';
    elseif isempty(strfind(texteReconnu, 'UNIROSS')) == 0
        fact=3;
        nom = 'UNIROSS';
    else
        fact = 1;
        nom = 'ALLIBERT';
    end
    
    for i=1:1:3
        ocrResults = ocr(imgNB,zones{i,fact});
        item{i} = strtrim(ocrResults.Text);
    end
    fprintf(fid,[num2str(D(n).name) ';' nom ';' regexprep(item{1},' ','') ';' regexprep(item{2},' ','') ';' regexprep(item{3},' ','') '\n']);
end

fclose(fid);

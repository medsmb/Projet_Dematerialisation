%nb = input(' Nombre de types de documents différents ');

D =[dir(fullfile('.','*.gif'));dir(fullfile('.','*.png'));dir(fullfile('.','*.jpeg'));dir(fullfile('.','*.jpg'));dir(fullfile('.','*.pdf'))];

chemin = strcat(D(1).folder,'\');
nbImg = size(D,1);
arg = ['le dossier contient ',num2str(nbImg),' images'];
condition=true;
while condition
   prompt=' 1-CATEGORISATION DES DOCMENTS \n 2-ROCONNAISSANCEET BASE DES DONNEES \n 3-QUITTER \n \n Valider votre choix ';
   c=input(prompt);
   if c==1
       disp(arg);
       h = multiwaitbar(3,[0 0 0 0],{'waitbar1...','waitbar2...','waitbar3...'});


for n=1:1:nbImg
    info = ['-- Traitement de l image ',D(n).name,' --'];
    info2 = ['-- Traitement de l image ',num2str(n),'/',num2str(nbImg),' --'];
      disp(info2);
    bin=['-- binarisation',sprintf(' %d files',n)];
     oc= ['-- calcul ocr ',num2str(n),'/',num2str(nbImg),' --'];  
    multiwaitbar(3,[n/nbImg,n/nbImg,n/nbImg],{info,bin,oc},h);
     fic = strcat(chemin,lower(D(n).name));
   
   img = imread(fic);
   
   %disp('-- calcul du seuil et binarisation --');
   seuil = graythresh(img);
   imgNB = imbinarize(img, seuil);
  % disp('-- calcul ocr --');
   ocrResults = ocr(imgNB);
   texteReconnu = upper(ocrResults.Text);
   %disp('-- classement image --');
    
   if ~contains(texteReconnu, 'DEMANDE') == 0 && ~contains(texteReconnu, 'PRIME') == 0 && ~contains(texteReconnu, 'DEMENAGEMENT') == 0 || ~contains(texteReconnu, 'DÉMÉNAGEMENT') == 0 
        mkdir PrimesDemenagement;
       imwrite(img, ['.\PrimesDemenagement\' D(n).name],'png');
   elseif ~contains(texteReconnu, 'DEMANDE') == 0 && ~contains(texteReconnu, 'AIDE') == 0 && ~contains(texteReconnu, 'LOGEMENT') == 0
        mkdir AidesLogement;
       imwrite(img, ['.\AidesLogement\' D(n).name],'png');
   elseif ~contains(texteReconnu, 'FACTURE') == 0
       mkdir Factures;
     imwrite(img, ['.\Factures\' D(n).name],'png');
   else
       mkdir Autres;
       imwrite(img, ['.\Autres\' D(n).name],'png');
   end
   mes=msgbox('Classement image','Success');    
end
  disp("------------------------------------------------");
   elseif c==2
        H = multiwaitbar(3,[0 0 0 0],{'waitbar1...','waitbar2...','waitbar3...'});

 D2 =[dir(fullfile('.\Factures','*.gif'));dir(fullfile('.\Factures','*.png'));dir(fullfile('.\Factures','*.jpeg'));dir(fullfile('.\Factures','*.jpg'))];


chemin2 = D2(1).name;


nbImg2 = size(D2,1);
        mkdir DATABASE; 
fid = fopen('.\DATABASE\factures.csv', 'a');

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

for n=1:1:nbImg2
      info1 = [' Traitement de l image ',D(n).name,' --'];
    info2 = ['-- Traitement de l image ',num2str(n),'/',num2str(nbImg2),' --'];
      disp(info2);
    bin1=['lecture de l image',sprintf(' %d files',n)];
     oc1= ['recherches des infos',num2str(n),'/',num2str(nbImg2),' --'];  
    multiwaitbar(3,[n/nbImg2,n/nbImg2,n/nbImg2],{info1,bin1,oc1},H);
    
    
    info = ['-- lecture de l image ',num2str(n),'/',num2str(nbImg2),' --'];
   % disp(info);
    fic = strcat('./Factures/',D2(n).name);
    
    img = imread(fic);
    %disp('-- calcul du seuil et binarisation --');
    seuil = graythresh(img);
    imgNB = imbinarize(img, seuil);
    %disp('-- calcul ocr --');
    ocrResults = ocr(imgNB, zone_recherche);
    texteReconnu = upper(ocrResults.Text);
    %disp('-- recherches des infos --');
    
    if ~contains(texteReconnu, 'MOREY') == 0
        fact = 2;
        nom = 'MOREY';
    elseif ~contains(texteReconnu, 'UNIROSS') == 0
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
    fprintf(fid,[num2str(D2(n).name) ';' nom ';' regexprep(item{1},' ','') ';' regexprep(item{2},' ','') ';' regexprep(item{3},' ','') '\n']);
end

fclose(fid);
delete(H.figure)
close(H)
message=msgbox('Le fichier .csv ','Success');
  disp("------------------------------------------------");
   elseif c==3
      break;
   else
       disp('Entrée invalide !');
         disp("------------------------------------------------");
   end
       
   
       

end
   
 


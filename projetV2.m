base = input('Veuillez indiquer le chemin du lot (ou son nom seul si dans répertoire courant)\n','s');

% récupération des fichiers png
pwddir = fullfile(base,'*.png');
D = dir(pwddir);

chemin = strcat(D(1).folder,'\');
nbImg = size(D,1);
disp(nbImg);

original_prime = imread('test\CourrierDev001.png');
seuil = graythresh(original_prime);
primeNB = imbinarize(original_prime, seuil);

original_aide = imread('test\CourrierDev002.png');
seuil = graythresh(original_aide);
aideNB = imbinarize(original_aide, seuil);

%Vérifie si les dossiers de destination sont vides
Factures = 'Factures';
PrimesDem = 'PrimesDemenagement';
AidesLog = 'AidesLogement';
extension = '*.png';
tableau = {Factures ; PrimesDem ; AidesLog};
for i = 1:size(tableau, 1)
    cheminFichiers = fullfile(char(tableau(i)), extension);
    fichiers = dir(cheminFichiers);
    if ~isempty(fichiers)
        delete(cheminFichiers);
        FichierDansDossier = strcat ('Suppresion des fichiers .png du dossier (', tableau(i) , ')' );
        disp(FichierDansDossier);
    else
        PasDeFichierDansDossier = strcat ('Le dossier (' , tableau(i), ') ne contient pas de fichier .png');
        disp(PasDeFichierDansDossier);
    end
end

for n=1:1:nbImg
    info = ['-- lecture de l image ',num2str(n),'/',num2str(nbImg),' --'];
    disp(info);
    fic = strcat(chemin,D(n).name);
    img = imread(fic);
    disp('-- calcul du seuil et binarisation --');
    seuil = graythresh(img);
    imgNB = imbinarize(img, seuil);
   
    disp('-- détection type fichier --');
     
    imgR = imresize(imgNB,size(primeNB));
    imgR2 = imresize(imgNB,size(aideNB));
    Z = imabsdiff(primeNB,imgR);
    MoyPrime=mean(Z(:));
    Z2 = imabsdiff(aideNB,imgR2);
    MoyAide=mean(Z2(:));
    
    disp('-- classement image --');
    
    if MoyPrime < 0.1
        imwrite(img, [PrimesDem '\' D(n).name],'png');
   elseif MoyAide <0.1
       imwrite(img, [AidesLog '\' D(n).name],'png');
   else
     imwrite(img, [Factures '\' D(n).name],'png');
   end
    
    
end



FasdUAS 1.101.10   ��   ��    k             l     ����  r       	  m     ��
�� boovfals 	 o      ���� 	0 debug  ��  ��     
  
 l     ��������  ��  ��        l     ��  ��     getType     �    g e t T y p e      l     ��  ��    I Cparses a string and returns everything after the last dot character     �   � p a r s e s   a   s t r i n g   a n d   r e t u r n s   e v e r y t h i n g   a f t e r   t h e   l a s t   d o t   c h a r a c t e r      i         I      �� ���� 0 gettype getType   ��  o      ���� 0 strfilename strFileName��  ��    k     P       r          m      ! ! � " "     o      ���� 0 	retstring     # $ # Y    M %�� & ' ( % Z    H ) *���� ) =     + , + n     - . - 4    �� /
�� 
cha  / o    ���� 0 i   . o    ���� 0 strfilename strFileName , m     0 0 � 1 1  . * k    D 2 2  3 4 3 Q    B 5 6�� 5 l   9 7 8 9 7 Y    9 :�� ; <�� : r   , 4 = > = b   , 2 ? @ ? o   , -���� 0 	retstring   @ l  - 1 A���� A n   - 1 B C B 4   . 1�� D
�� 
cha  D o   / 0���� 0 j   C o   - .���� 0 strfilename strFileName��  ��   > o      ���� 0 	retstring  �� 0 j   ; [     # E F E o     !���� 0 i   F m   ! "����  < n   # ' G H G 1   $ &��
�� 
leng H o   # $���� 0 strfilename strFileName��   8 8 2the following could fail if the . is the last char    9 � I I d t h e   f o l l o w i n g   c o u l d   f a i l   i f   t h e   .   i s   t h e   l a s t   c h a r 6 R      ������
�� .ascrerr ****      � ****��  ��  ��   4  J�� J  S   C D��  ��  ��  �� 0 i   & n     K L K 1    
��
�� 
leng L o    ���� 0 strfilename strFileName ' m    ����  ( m    ������ $  M�� M L   N P N N o   N O���� 0 	retstring  ��     O P O l     ��������  ��  ��   P  Q R Q l     �� S T��   S  
parentPath    T � U U  p a r e n t P a t h R  V W V l     �� X Y��   X $ returns the path of the parent    Y � Z Z < r e t u r n s   t h e   p a t h   o f   t h e   p a r e n t W  [ \ [ i     ] ^ ] I      �� _���� 0 
parentpath 
parentPath _  `�� ` o      ���� 0 strpath strPath��  ��   ^ k     @ a a  b c b r      d e d m      f f � g g   e o      ���� 0 	retstring   c  h i h Y    = j�� k l m j Z    8 n o���� n =     p q p n     r s r 4    �� t
�� 
cha  t o    ���� 0 i   s o    ���� 0 strpath strPath q m     u u � v v  : o k    4 w w  x y x Y    2 z�� { |�� z r   % - } ~ } b   % +  �  o   % &���� 0 	retstring   � l  & * ����� � n   & * � � � 4   ' *�� �
�� 
cha  � o   ( )���� 0 j   � o   & '���� 0 strpath strPath��  ��   ~ o      ���� 0 	retstring  �� 0 j   { m    ����  | o     ���� 0 i  ��   y  ��� �  S   3 4��  ��  ��  �� 0 i   k \     � � � l   
 ����� � n    
 � � � 1    
��
�� 
leng � o    ���� 0 strpath strPath��  ��   � m   
 ����  l m    ����  m m    ������ i  ��� � L   > @ � � o   > ?���� 0 	retstring  ��   \  � � � l     ��������  ��  ��   �  � � � l     �� � ���   �  readFile    � � � �  r e a d F i l e �  � � � i     � � � I      �� ����� 0 readfile readFile �  ��� � o      ���� 0 unixpath unixPath��  ��   � k     ! � �  � � � r     
 � � � l     ����� � I    �� ���
�� .rdwropenshor       file � l     ����� � 4     �� �
�� 
psxf � o    ���� 0 unixpath unixPath��  ��  ��  ��  ��   � o      ���� 0 foo   �  � � � r     � � � l    ����� � I   �� � �
�� .rdwrread****        **** � o    ���� 0 foo   � �� ���
�� 
rdfr � l    ����� � I   �� ���
�� .rdwrgeofcomp       **** � o    ���� 0 foo  ��  ��  ��  ��  ��  ��   � o      ���� 0 txt   �  � � � I   �� ���
�� .rdwrclosnull���     **** � o    ���� 0 foo  ��   �  ��� � L    ! � � o     ���� 0 txt  ��   �  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� $0 searchandreplace searchAndReplace �  � � � o      ���� 0 txt   �  � � � o      ���� 0 srch   �  ��� � o      ���� 0 rpl  ��  ��   � k     * � �  � � � r      � � � n     � � � 1    ��
�� 
txdl � 1     ��
�� 
ascr � o      ���� 
0 oldtid   �  � � � r     � � � J    	 � �  �� � o    �~�~ 0 srch  �   � n      � � � 1   
 �}
�} 
txdl � 1   	 
�|
�| 
ascr �  � � � r     � � � n     � � � 2    �{
�{ 
citm � o    �z�z 0 txt   � o      �y�y 0 temp   �  � � � r     � � � J     � �  ��x � o    �w�w 0 rpl  �x   � n      � � � 1    �v
�v 
txdl � 1    �u
�u 
ascr �  � � � r    ! � � � l    ��t�s � c     � � � o    �r�r 0 temp   � m    �q
�q 
TEXT�t  �s   � o      �p�p 0 temp   �  � � � r   " ' � � � o   " #�o�o 
0 oldtid   � n      � � � 1   $ &�n
�n 
txdl � 1   # $�m
�m 
ascr �  ��l � L   ( * � � o   ( )�k�k 0 temp  �l   �  � � � l     �j�i�h�j  �i  �h   �  � � � i     � � � I      �g ��f�g 0 findcharafter findCharAfter �  � � � o      �e�e 0 txt   �  � � � o      �d�d 0 lb   �  ��c � o      �b�b 0 
startindex 
startIndex�c  �f   � k     ` � �  � � � r      � � � m     �a�a�� � o      �`�` 0 retindex retIndex �  � � � Y    ] ��_ � �  � k    X  Y    D�^ Q    ?	�] Z   ! 6
�\�[
 >  ! . n   ! ) 4   " )�Z
�Z 
cha  l  # (�Y�X \   # ( [   # & o   # $�W�W 0 i   o   $ %�V�V 0 j   m   & '�U�U �Y  �X   o   ! "�T�T 0 txt   n   ) - 4   * -�S
�S 
cha  o   + ,�R�R 0 j   o   ) *�Q�Q 0 lb    S   1 2�\  �[  	 R      �P�O�N
�P .ascrerr ****      � ****�O  �N  �]  �^ 0 j   m    �M�M  l   �L�K n     1    �J
�J 
leng o    �I�I 0 lb  �L  �K   m    �H�H  �G Z   E X�F�E =   E J  o   E F�D�D 0 j    l  F I!�C�B! n   F I"#" 1   G I�A
�A 
leng# o   F G�@�@ 0 lb  �C  �B   k   M T$$ %&% r   M R'(' l  M P)�?�>) [   M P*+* o   M N�=�= 0 i  + o   N O�<�< 0 j  �?  �>  ( o      �;�; 0 retindex retIndex& ,�:,  S   S T�:  �F  �E  �G  �_ 0 i   � o    �9�9 0 
startindex 
startIndex � l   -�8�7- n    ./. 1   	 �6
�6 
leng/ o    	�5�5 0 txt  �8  �7    m    �4�4  � 0�30 L   ^ `11 o   ^ _�2�2 0 retindex retIndex�3   � 232 l     �1�0�/�1  �0  �/  3 454 i    676 I      �.8�-�. .0 sendstatusdownmessage sendStatusDownMessage8 9:9 o      �,�, 0 recipientname recipientName: ;�+; o      �*�* $0 recipientaddress recipientAddress�+  �-  7 k     9<< =>= r     ?@? m     AA �BB   N Y U   C l a s s e s   D o w n@ o      �)�) 0 
thesubject 
theSubject> CDC r    EFE m    GG �HH p L o g g i n g   i n t o   N Y U   C l a s s e s   f a i l e d .     P l e a s e   v e r i f y   M a n u a l l yF o      �(�( 0 
thecontent 
theContentD IJI l   �'�&�%�'  �&  �%  J K�$K O    9LML k    8NN OPO l   �#QR�#  Q  Create the message   R �SS $ C r e a t e   t h e   m e s s a g eP TUT r    VWV I   �"�!X
�" .corecrel****      � null�!  X � YZ
�  
koclY m    �
� 
bckeZ �[�
� 
prdt[ K    \\ �]^
� 
subj] o    �� 0 
thesubject 
theSubject^ �_`
� 
ctnt_ o    �� 0 
thecontent 
theContent` �a�
� 
pvisa m    �
� boovtrue�  �  W o      �� 0 
themessage 
theMessageU bcb l   �de�  d  Set a recipient   e �ff  S e t   a   r e c i p i e n tc g�g O    8hih k   # 7jj klk I  # 1��m
� .corecrel****      � null�  m �no
� 
kocln m   % &�
� 
trcpo �p�
� 
prdtp K   ' -qq �rs
� 
pnamr o   ( )�� 0 recipientname recipientNames �
t�	
�
 
raddt o   * +�� $0 recipientaddress recipientAddress�	  �  l uvu l  2 2�wx�  w  Send the Message   x �yy   S e n d   t h e   M e s s a g ev z�z I  2 7���
� .emsgsendnull���     bcke�  �  �  i o     �� 0 
themessage 
theMessage�  M m    	{{�                                                                                  emal  alis    F  Macintosh HD               �:�H+     kMail.app                                                        W��0w        ����  	                Applications    �;/W      �h�       k  #Macintosh HD:Applications: Mail.app     M a i l . a p p    M a c i n t o s h   H D  Applications/Mail.app   / ��  �$  5 |}| l     �� ���  �   ��  } ~~ i    ��� I      ������� *0 sendstatusupmessage sendStatusUpMessage� ��� o      ���� 0 recipientname recipientName� ���� o      ���� $0 recipientaddress recipientAddress��  ��  � k     9�� ��� r     ��� m     �� ���  N Y U   C l a s s e s   U p� o      ���� 0 
thesubject 
theSubject� ��� r    ��� m    �� ��� v L o g g i n g   i n t o   N Y U   C l a s s e s   S u c c e e d e d .     P l e a s e   v e r i f y   M a n u a l l y� o      ���� 0 
thecontent 
theContent� ��� l   ��������  ��  ��  � ���� O    9��� k    8�� ��� l   ������  �  Create the message   � ��� $ C r e a t e   t h e   m e s s a g e� ��� r    ��� I   �����
�� .corecrel****      � null��  � ����
�� 
kocl� m    ��
�� 
bcke� �����
�� 
prdt� K    �� ����
�� 
subj� o    ���� 0 
thesubject 
theSubject� ����
�� 
ctnt� o    ���� 0 
thecontent 
theContent� �����
�� 
pvis� m    ��
�� boovtrue��  ��  � o      ���� 0 
themessage 
theMessage� ��� l   ������  �  Set a recipient   � ���  S e t   a   r e c i p i e n t� ���� O    8��� k   # 7�� ��� I  # 1�����
�� .corecrel****      � null��  � ����
�� 
kocl� m   % &��
�� 
trcp� �����
�� 
prdt� K   ' -�� ����
�� 
pnam� o   ( )���� 0 recipientname recipientName� �����
�� 
radd� o   * +���� $0 recipientaddress recipientAddress��  ��  � ��� l  2 2������  �  Send the Message   � ���   S e n d   t h e   M e s s a g e� ���� I  2 7������
�� .emsgsendnull���     bcke��  ��  ��  � o     ���� 0 
themessage 
theMessage��  � m    	���                                                                                  emal  alis    F  Macintosh HD               �:�H+     kMail.app                                                        W��0w        ����  	                Applications    �;/W      �h�       k  #Macintosh HD:Applications: Mail.app     M a i l . a p p    M a c i n t o s h   H D  Applications/Mail.app   / ��  ��   ��� l     ��������  ��  ��  � ��� l     ������  � # The index we're starting from   � ��� : T h e   i n d e x   w e ' r e   s t a r t i n g   f r o m� ��� l     ������  � b \We initialize this variable here, so that it never gets reset (unless the script is stopped)   � ��� � W e   i n i t i a l i z e   t h i s   v a r i a b l e   h e r e ,   s o   t h a t   i t   n e v e r   g e t s   r e s e t   ( u n l e s s   t h e   s c r i p t   i s   s t o p p e d )� ��� l     ������  � ` ZThis helps to ensure that each loop iteration is checking a new portion of the results log   � ��� � T h i s   h e l p s   t o   e n s u r e   t h a t   e a c h   l o o p   i t e r a t i o n   i s   c h e c k i n g   a   n e w   p o r t i o n   o f   t h e   r e s u l t s   l o g� ��� l   ������ r    ��� m    ����  � o      ����  0 lastmatchindex lastMatchIndex��  ��  � ��� l   ������ r    ��� m    	��
�� boovtrue� o      ����  0 laststatusgood lastStatusGood��  ��  � ��� l     ��������  ��  ��  � ��� l  z������ V   z��� k   u�� ��� Z    ������� o    ���� 	0 debug  � I   �����
�� .sysodlogaskr        TEXT� l   ������ m    �� ���  i n t e r r u p t��  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ��� r     )��� l    '������ l    '������ I    '����
�� .earsffdralis        afdr�  f     !� �����
�� 
rtyp� m   " #��
�� 
ctxt��  ��  ��  ��  ��  � o      ���� 0 mypath myPath� ��� r   * 2��� I   * 0�� ���� 0 
parentpath 
parentPath  �� o   + ,���� 0 mypath myPath��  ��  � o      ���� 0 mypath myPath�  r   3 : b   3 8 b   3 6	 o   3 4���� 0 mypath myPath	 m   4 5

 �  R e s u l t s m   6 7 �  : o      ���� 0 mypath myPath  l  ; ;��������  ��  ��    O   ; � k   ? �  r   ? G n   ? E 1   C E��
�� 
ects 4   ? C��
�� 
cfol o   A B���� 0 mypath myPath o      ���� 0 filelist fileList  r   H W I  H U�� !
�� .DATASORTobj ���     obj   o   H I���� 0 filelist fileList! ��"��
�� 
by  " 1   L Q��
�� 
asmo��   o      ���� 0 filelist fileList #$# r   X f%&% n   X b'(' 1   ^ b��
�� 
pnam( n  X ^)*) 4  Y ^��+
�� 
cobj+ m   \ ]���� * o   X Y���� 0 filelist fileList& o      ���� 0 thetext theText$ ,-, r   g t./. b   g p010 b   g l232 o   g h���� 0 mypath myPath3 o   h k���� 0 thetext theText1 m   l o44 �55  :/ o      ���� 0 thetext theText- 6��6 r   u �787 I  u ���9:
�� .rdwrread****        ****9 4   u }��;
�� 
file; o   y |���� 0 thetext theText: ��<��
�� 
as  < m   � ���
�� 
ctxt��  8 o      ���� 0 
thecontent 
theContent��   m   ; <==�                                                                                  MACS  alis    t  Macintosh HD               �:�H+     N
Finder.app                                                      �S��R        ����  	                CoreServices    �;/W      �͒       N   H   G  6Macintosh HD:System: Library: CoreServices: Finder.app   
 F i n d e r . a p p    M a c i n t o s h   H D  &System/Library/CoreServices/Finder.app  / ��   >?> l  � ���������  ��  ��  ? @A@ r   � �BCB m   � �DD �EE 8 n u m b e r   o f   f a i l i n g   s a m p l e s   :  C o      ���� 0 searchphrase searchPhraseA FGF r   � �HIH m   � �����  I o      ���� 0 
matchindex 
matchIndexG JKJ V   �]LML k   �XNN OPO r   � �QRQ I   � ���S���� 0 findcharafter findCharAfterS TUT o   � ��� 0 
thecontent 
theContentU VWV o   � ��~�~ 0 searchphrase searchPhraseW X�}X o   � ��|�|  0 lastmatchindex lastMatchIndex�}  ��  R o      �{�{ 0 
matchindex 
matchIndexP YZY l  � ��z�y�x�z  �y  �x  Z [\[ Z   � �]^�w�v] >  � �_`_ o   � ��u�u 0 
matchindex 
matchIndex` m   � ��t�t��^ r   � �aba o   � ��s�s 0 
matchindex 
matchIndexb o      �r�r  0 lastmatchindex lastMatchIndex�w  �v  \ cdc l  � ��q�p�o�q  �p  �o  d e�ne Z   �Xfg�m�lf F   � �hih >  � �jkj o   � ��k�k 0 
matchindex 
matchIndexk m   � ��j�j��i >  � �lml o   � ��i�i 0 
matchindex 
matchIndexm m   � ��h�h  g Z   �Tno�gpn >  � �qrq n   � �sts 4   � ��fu
�f 
cha u o   � ��e�e 0 
matchindex 
matchIndext o   � ��d�d 0 
thecontent 
theContentr m   � �vv �ww  0o k   �xx yzy l  � ��c{|�c  {   server is down   | �}}    s e r v e r   i s   d o w nz ~~ Z   ����b�a� =  � ���� o   � ��`�`  0 laststatusgood lastStatusGood� m   � ��_
�_ boovtrue� Z   ����^�� o   � ��]�] 	0 debug  � I  � ��\��[
�\ .sysodlogaskr        TEXT� l  � ���Z�Y� m   � ��� ��� . s e r v e r   h a s   g o n e   o f f l i n e�Z  �Y  �[  �^  � k   ��� ��� I   �
�X��W�X *0 sendstatusupmessage sendStatusUpMessage� ��� m   �� ���  F i r s t   L a s t� ��V� m  �� ��� * a c c o u n t @ s e r v e r . d o m a i n�V  �W  � ��U� I  �T��S�T *0 sendstatusupmessage sendStatusUpMessage� ��� m  �� ���  F i r s t   L a s t� ��R� m  �� ��� * a c c o u n t @ s e r v e r . d o m a i n�R  �S  �U  �b  �a   ��Q� r  ��� m  �P
�P boovfals� o      �O�O  0 laststatusgood lastStatusGood�Q  �g  p k  !T�� ��� l !!�N���N  �  server is up   � ���  s e r v e r   i s   u p� ��� Z  !P���M�L� = !$��� o  !"�K�K  0 laststatusgood lastStatusGood� m  "#�J
�J boovfals� Z  'L���I�� o  '(�H�H 	0 debug  � I +2�G��F
�G .sysodlogaskr        TEXT� l +.��E�D� m  +.�� ��� * s e r v e r   i s   b a c k   o n l i n e�E  �D  �F  �I  � k  5L�� ��� I  5@�C��B�C *0 sendstatusupmessage sendStatusUpMessage� ��� m  69�� ���  F i r s t   L a s t� ��A� m  9<�� ��� * a c c o u n t @ s e r v e r . d o m a i n�A  �B  � ��@� I  AL�?��>�? *0 sendstatusupmessage sendStatusUpMessage� ��� m  BE�� ���  F i r s t   L a s t� ��=� m  EH�� ��� * a c c o u n t @ s e r v e r . d o m a i n�=  �>  �@  �M  �L  � ��<� r  QT��� m  QR�;
�; boovtrue� o      �:�:  0 laststatusgood lastStatusGood�<  �m  �l  �n  M >  � ���� o   � ��9�9 0 
matchindex 
matchIndex� m   � ��8�8��K ��� l ^^�7�6�5�7  �6  �5  � ��� Z  ^s���4�� o  ^_�3�3 	0 debug  � I bi�2��1
�2 .sysodelanull��� ��� nmbr� m  be�0�0 �1  �4  � I ls�/��.
�/ .sysodelanull��� ��� nmbr� m  lo�-�- <�.  � ��,� l tt�+�*�)�+  �*  �)  �,  � m    �(
�( boovtrue��  ��  � ��� l     �'�&�%�'  �&  �%  � ��� l     �$�#�"�$  �#  �"  � ��!� l     � ���   �  �  �!       
�����������  � ��������� 0 gettype getType� 0 
parentpath 
parentPath� 0 readfile readFile� $0 searchandreplace searchAndReplace� 0 findcharafter findCharAfter� .0 sendstatusdownmessage sendStatusDownMessage� *0 sendstatusupmessage sendStatusUpMessage
� .aevtoappnull  �   � ****� � ������ 0 gettype getType� ��� �  �� 0 strfilename strFileName�  � ����� 0 strfilename strFileName� 0 	retstring  � 0 i  � 0 j  �  !�
�	 0��
�
 
leng
�	 
cha �  �  � Q�E�O H��,Ekih ��/�  / ! �k��,Ekh ���/%E�[OY��W X  hOY h[OY��O�� � ^������ 0 
parentpath 
parentPath� ��� �  �� 0 strpath strPath�  � � �������  0 strpath strPath�� 0 	retstring  �� 0 i  �� 0 j  �  f���� u
�� 
leng
�� 
cha � A�E�O 8��,kkih ��/�   k�kh ���/%E�[OY��OY h[OY��O�� �� ����������� 0 readfile readFile�� ����� �  ���� 0 unixpath unixPath��  � �������� 0 unixpath unixPath�� 0 foo  �� 0 txt  � ������������
�� 
psxf
�� .rdwropenshor       file
�� 
rdfr
�� .rdwrgeofcomp       ****
�� .rdwrread****        ****
�� .rdwrclosnull���     ****�� "*�/j E�O��j l E�O�j O�� �� ����������� $0 searchandreplace searchAndReplace�� ����� �  �������� 0 txt  �� 0 srch  �� 0 rpl  ��  � ������������ 0 txt  �� 0 srch  �� 0 rpl  �� 
0 oldtid  �� 0 temp  � ��������
�� 
ascr
�� 
txdl
�� 
citm
�� 
TEXT�� +��,E�O�kv��,FO��-E�O�kv��,FO��&E�O���,FO�� �� ����������� 0 findcharafter findCharAfter�� ����� �  �������� 0 txt  �� 0 lb  �� 0 
startindex 
startIndex��  � �������������� 0 txt  �� 0 lb  �� 0 
startindex 
startIndex�� 0 retindex retIndex�� 0 i  �� 0 j  � ��������
�� 
leng
�� 
cha ��  ��  �� aiE�O X���,Ekh  2k��,Ekh  �ᤥk/��/ Y hW X  h[OY��O���,  ��E�OY h[OY��O�� ��7���������� .0 sendstatusdownmessage sendStatusDownMessage�� ����� �  ������ 0 recipientname recipientName�� $0 recipientaddress recipientAddress��  � ������������ 0 recipientname recipientName�� $0 recipientaddress recipientAddress�� 0 
thesubject 
theSubject�� 0 
thecontent 
theContent�� 0 
themessage 
theMessage� AG{��������������������������
�� 
kocl
�� 
bcke
�� 
prdt
�� 
subj
�� 
ctnt
�� 
pvis�� �� 
�� .corecrel****      � null
�� 
trcp
�� 
pnam
�� 
radd
�� .emsgsendnull���     bcke�� :�E�O�E�O� .*������e�� E�O� *�������� O*j UU� ������������� *0 sendstatusupmessage sendStatusUpMessage�� ����� �  ������ 0 recipientname recipientName�� $0 recipientaddress recipientAddress��  � ������������ 0 recipientname recipientName�� $0 recipientaddress recipientAddress�� 0 
thesubject 
theSubject�� 0 
thecontent 
theContent�� 0 
themessage 
theMessage� �����������������������������
�� 
kocl
�� 
bcke
�� 
prdt
�� 
subj
�� 
ctnt
�� 
pvis�� �� 
�� .corecrel****      � null
�� 
trcp
�� 
pnam
�� 
radd
�� .emsgsendnull���     bcke�� :�E�O�E�O� .*������e�� E�O� *�������� O*j UU� �����������
�� .aevtoappnull  �   � ****� k    z��  �� �   � �����  ��  ��  �  � 0�������������������
=������������������4��~�}�|D�{�z�y�x�wv����v��������u�t�s�� 	0 debug  ��  0 lastmatchindex lastMatchIndex��  0 laststatusgood lastStatusGood
�� .sysodlogaskr        TEXT
�� 
rtyp
�� 
ctxt
�� .earsffdralis        afdr�� 0 mypath myPath�� 0 
parentpath 
parentPath
�� 
cfol
�� 
ects�� 0 filelist fileList
�� 
by  
�� 
asmo
�� .DATASORTobj ���     obj 
�� 
cobj
�� 
pnam�� 0 thetext theText
� 
file
�~ 
as  
�} .rdwrread****        ****�| 0 
thecontent 
theContent�{ 0 searchphrase searchPhrase�z 0 
matchindex 
matchIndex�y 0 findcharafter findCharAfter
�x 
bool
�w 
cha �v *0 sendstatusupmessage sendStatusUpMessage�u 
�t .sysodelanull��� ��� nmbr�s <��{fE�OjE�OeE�Omhe� 
�j Y hO)��l E�O*�k+ 	E�O��%�%E�O� L*��/�,E�O�a *a ,l E�O�a k/a ,E` O�_ %a %E` O*a _ /a �l E` UOa E` OjE` O �h_ i*_ _ �m+ E` O_ i 
_ E�Y hO_ i	 _ ja & _ a  _ /a ! 8�e  *� a "j Y *a #a $l+ %O*a &a 'l+ %Y hOfE�Y 5�f  *� a (j Y *a )a *l+ %O*a +a ,l+ %Y hOeE�Y h[OY�BO� a -j .Y 	a /j .OP[OY��ascr  ��ޭ
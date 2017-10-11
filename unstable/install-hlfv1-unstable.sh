ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� h)�Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H�����"��#A�ED�����X64xd���Y��=��B����m�,���,dv5Y����6�L�6�d~0`m�O�C����� SGj����1�b�lږK� x�%l	���3V���fb��{��:(T2���b6��?z ��?Q�h���N����Ȇ*�!A�����)!H���X[��A�2e����
�0��ӁU�b"�V,T�*���j�bc����n���jB�@��;���'�ٴy�Rl2i�&�k:Z<��7mM�k��,��,��:�� ���@�U]1(,�`�*^k]qb���^����CM�F>��>C��S�*jP����v�2Ga6Ud�[���gԧ�:�z��(ۡ�G9�.`��#:����/;��|�X0
�e+��p��Ej��N>M���P9\��,[�㍿i�2~1�;=~i���sF��S7G6����5�GY�Qyl�)ua�H��Ou	3ߔb�y�v
eLĶ����5����3���f��ա�{�]��4�>�%��냇�}n+�����u��>�{�ɋǣ��?
����rQc�#���̀/�����6"n��}Zͻ���?:��p��4"�âDןpBl����|�iF��&ga�T��>�����I5&�|��+�*G�T��~��M|�=��T�)�Aǐ8�Y�`]�k��Oe�.�g�1���U�Z��l�!���`�-l�K��O�{�'�������E@7����:3��؉/�`�-�>�Az����,`c@g�s�l@�d��E:��C1�vZ6�8&ݙy�vL�m�5�t+2y�������	OC����A�E6��Iө�Mlh����ni}�۔�б�؜>sJy5��隂��-�i�@�;���IdG��v��X��^�t���&�O�x��P�v�7�d�ݰ��s�+����[�y�9����4�.����� �G��@���- �=-Y���v�K�R�S$��Xi�q���Ġ������{OSO�uH� ;�p����|�`�'�z�����������?,�����J`��� �偺c��|`7�Z��h��Dm�E��1�h�^
Y�_ɲq��&w�q�����*c!б@��&���[�M�ă�n�<x���4�*@J~��GiC���vx ��B�aC޹���'���5�xx�q8�zxn�e:�a�7i�lF���Ŭ?�x|��[2@�!�Ϙ����p�i���y[�q�ޢk��cv	d�=��ve~l� ��yn`���e�)���&�QA �Mq6�>�������3�'1ǟ��ҧ�+R����E���٬����Ǿ�$��p����#h!`!)6�55�	0�l����܏��sƜ�{�&�ެ#��朧��G�o ͠��x��8�"�pߨ�&�2�({��M&N� ���^�!N��#�S��z�5��.4�+GT8hm��T�a�)#����۟�Ģqam�W��/f��h-祉%�/J��������Հ�'�G�0�w�-�3���Ӯu�L���vs&��N�c������f�K��;��N��n��*��;?݄�j���ٕ�����Wcȃg�K�Y\/7+'��ԇ�L��?(����f��@ ��B�K�[N�6����&+�xQE�-4�&�H�ϞN>"��;����T�r�C5_�U��zmV��(xn!�X��ym�wĨ;��h�ٟ�
���OYT��w��[�tf�;OM޿���9�s������p�5d����ï�[
DZ��ɒ�NO��7���������?����"��1b3��Bv6�伈��X�[�a!���Vk��ˆ��?h���\&�Q�����Z�W�/�ܓO����6�� �������qB��g��Z��0C�������L����������?W �ן�p���^�Fp��+����]���������G"���_	L����]86�ܴl�L�/A���{!�nCC��݁P�Z{d�w],�~rL�������3���ϋO���|LD�V�����1���]�,���[6jdDz���"#��S��{U:���z9�}�L:s#d�E�߱w�:V�N��l�=1� `��������+�6�0��Sȣ3��b�E
V�x�L�_O�s���}�L�N��5�>��EG�X�\�����KP�2����"���������?���Tk�P�:^���.�,|tFT
}{�� 7����@=������A!(.�W୰dtoS���{�6��4��D���S��KP�2��J�)�G#k�_	����8�,���5�6�������O�	���f8~Tp~���M��./����Ʀ�_�G��+��������n�"۝Y���!w� � i�0���a6�� \�E��yT9�3CP���J�#L� ����Ѐ7�9���*D��� s�?�p�FO�E/n�.�x���)J��K6`�5��g�ز�$#^2/i���c:E�D�	&�,���%���ac*5����O'˘�c��X.�ɡN%�yz�{P�f�Y�?e^���<3|Dxn�6�df]]�hB��Bdx��g%�nl�W3�������<���5�'�q��1������[��H���)h_,k�.����B4>}��J��ϕ �_s���|����������k����?�HMP$)�ت+�"J	X��%e+���k���C$�H�I�Z"")PJD	�ߊ�k[���|���kn�������ɝ����8"��7�_Q���ۧ��M[s����O��Ђ�ʿ���6���$��ꛯFtx��=�ugm�����n��ɐ�O�oNL�y5��?l<&H����6��
�8?x�o��Ͻ�.�^���{�6n��#�Z��>q��t�7ic��__)&D��p�����ҭ���2�1�BJo���a��4�&~����M'K��+����-�6>v����aM@�X�.(񭈰U�J��"ն��� ��-
JD(n�a�&�!L@I��I�O�WQ�uj�p��\�R�r5�ͧ�j���3
�|*w�J�J�!��I��/�E��8.�諡d����5�i�^�q���g��s!Cp{�ef�P�[9Y<�$����q�"s)����1!UM���ZNo�"�x��Ȟ�G�3��>&ϴd���iX�<o]��W3�D��2㜽i6ko��Y%z^�i�8�j&\l�3��31{�M�X�*��y>\�慃j>|B��Y�0,{g��'k���K�N�ǥR.�{}|t�����ѥ���R8k����ҎvN���B����P|g��N>s�?=���7���e�^H
C��NJ'e�De2F��Q.k+�}�]�֪�32��B.���������R)�s/�+y9�s��.�%1׺�T�x�/��N�NΣv,M��\}��5�['�q�|T?�{�^�M��g�N/�U���VA=,�ΤL?���W����,�� �UӽL2�+�5�m�����r!)׷2�,R���Z�Ԟ�O��3�ē�d�a��[����N�H@�B*+h���]��NA����
�d�!2G�|)%Y{��;#�i|�UO��/ѓD�i�����QT1N�zǉnJ5�Jt/����}gq�3�^!w*�7ǅ�C(h����w��QY�yg0���3Ā�P0��>6���z 3������/�nnH�D1&����������o��_)|�������>�{�kX��/��G���DD1���[	��I���11`/s�Js�|n��dy��N��>T���|o?���PBk�b����X��oP1w��]=�F�ey�d��&q�R�\6�)�tT,w
G��,L�_\K픎_�P�1'����r���(zt��i�T��8�ة�Q*r(}���ӻU�Q��ą�cη|���g����/]��ѵ�_|6���>�����a�ó��:��J`��%��q�m�2��]��#%�����\Rҥ����ɦ�`5��pq�pB��^7:�y���Y��� �)��q���DcwĽ��֥m�mC>���ֻ��Q�ô���7��=�ܳ�ہO��~��4���5�}x�_	["�����Qi��q5��p�o���|�@��� �u�i�ʈ���(��������6����5dn�Q�[�G���F ���Fu��X��Ө.hh��@�mh��~�E-����}vi�?��e�8��5� ���~g� i܆����X�}�M)�R�*V���EPC:�$�jtd#0�`��zú2�1�]l��/y�s��<�F�={�P���y��N�>4�>�#���8Z��2��d�k�{u]�xͦ?v5�B42����>vL��k���U����-У{�`��H�"2}�F/]it)xtذ�@h h��O���_��!���0*�Ӷ-�v���=���UOޞLI ��裣���&�6���/lP�%��ay�^���Ȝa���Le@}���(����&��g���TDU�Oph�T��/����Kwu�I��3�����p��A�|s9y0��r����>��.�2���۬3t�>izIj%"B^�/���e�.���c�1m;��u�I��vE���̉�u�2��7���ql�8\\�o*@ [JY1X#83�T���ˇS.C	|8�B\;�݋�T "�66��JإH�C�-F�"���G�1�e x]Jt�[��Bn�����[K��'���C�;�1~��\�^���h�%�Y�͗��n���e�6Tt�W��M��7L_����U��l�Ql�>���5�N�`��u#�v�*C:14�t۱:!D�(�c)"�b86�԰���y*��dM[������;:��kh".�htB�
�*�ݞ��c�W��k�G:��ꄎ�m��\�Ӿ�~�Hd�v;d�|�1O�i0 ß_|0q:�Xn���Au�C�mPQ�3| ��*����X����wj��l�?=���b�� ���m,���R��ٻ�XǱ����4w�S�����nԗ*?;�eJj;v��y:OWN�$N�Ǎ�8��4-�4�� v3��`�،@�� ,b�����q�U��:�շ�����s����6��A�{I��G�P�K��������_|{�W�����s��������_��7��K��q�s��,��8z����:�1�
�n]C���ga*Ɋ�I��"����p�)��B����12܊�BFe� ȶ�r���$��G�������7��'���G�����}A�������!������}���V����﾿`�������{���!�5����������i���� 톋! -V h1e��
l���F��cCK�R
���&�ҧL�s���r�B��{�����«\p�CW5�e�
�ݨ*�%0#�5�:�M��i%ab��&�^}.�
��kHֳ����=C��0�/鴍@���V��`r��x����|��́��u3A�w)��Ek�Nq��6�q��΄b�L�0�)7g���A%\��f3Y�։�!M3فyX��g{��;�5��~���:�F�}��_���@Μw��s�0���X?ŗF�˗ٱ�k�A'r�B��:�7��2���J��9S��2ee$�R�-$0��,by��B�Z�Nr �Q�K[�#��$�$��ɚ0�hg.�4��-�1����)t����Gt��"n*���� i�I�;
S�_-2�a����71�lѪ�H��b�C�r�`��d�j��X͔��qg��r��/O3�N�OִV���Y�T6�tr�g�&%��Frʏ�C
m!Z�K��l~�]���t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�py	c0�"o�R4x�$��?\�(%��cO�p���cLo�S�lӊ��b[���vV8�rr�D��A�C!U���A�ꉚ)��n����۩��?�n{���C������9Cd�x6d��FU,�zm��G�j���M��	����sS�<N��p�hjr,_���hl��6Y��V?��n�~"��>�ӱ0&!�2��-k9B�©�D��&ފ�<e���s�B���S�p,�#S.�|&;��ә2k&��j'�.Ȑ���d?�ӵL���Z6�'.�;��T�Q�MZyD�ڬ�����,J�K�̻��z�������oY��q�ڣ���-���
`�^�/���^	��g�{q�\l��a~���E���;G_�}���C��5�S�E/��7�@���˛�7�y��X��> ����� ��@|�?�ƣ:��<|�a�z���?�R�e��(������,'�*�g��,)�(��������u~��K�Ώ�|�2�`a9�,%r�Y���+���X�~Ʌآ�`rGt�Ʀ�	Lٕ�9 |�
L��H�L��(�Y)�aL��,�T��*0K<��L�8�>f�y%�+ 1*��N�� ��߬����o���E�M�����1o�i=ڮ.k�D����te�GM�&�9[�D���jY��I���d:u�N�t�o0"�i
�d�SP�8#5��@eh����v�8^9�D)9:�$�|���Q�J����>E�e'��Y��UZ�)�~��l�b�<TpLTj�p���,�F6т>��b!���Ƙ^`�8�e�J7�)Ǎ�0S�{�0����N|�ۿ�x�[W2M�M�P.��(ϗa��p�LN�L�����p�_����M9��+����]W?"W1�+r!��/�=n�e���6����3�{fVz\�ew���;m�]w�g��~��M��pĿ�\�C˞l�j5�7fI�g�D=���l���Ò�͠���Z(���2�g�S�(F�,1��\��<=���^mdi�T?�fNߡ�Z�M�P�lC9.дyj3K��L~Dw���@�:�|��$R�YGkO�#������Z�`��|�O��-U]�*,�.-H��V-�W����NU�bYs�Rd�F�P�7�yC�R�bQ��Ê�h2�l��)��"t�5\�W�u�~�1B��Q4�,<��M��W�DV�d�R$Bv6(��552����RHزJ�&�_E22���H�	�~Ԑ��I*�G0�2AVv��D��c�2)s�U(��{�B)���B��:���uJ+�9$O�j��pI�?��:ݮ�Y�P�;�<Ǹ�ѱR=�������V.�*�dH[F�3�.��Qn�PW��P(�r�.������piJ
^ԇf�����y�S�y�� }),����)��f�R��;�4YhΧ8)W�tC�k��<O�HX#H���&��Q�1K�:6�MS`��QXbe��Bl4Z�X)�j9�2f�����.����,��.}7���t�
��x�2���|�B��K�C�-*�1Q��b�#7�_F~��*C}����xxySi#/�c�g�huK�R	�x�y���s���σ^�o!��<��()�n�M�b���S����Q�4U�}H���5�I\����)I!ki�3�*��i�8"�����8Xɐ�%��s:�Sw��V����G8�C��D�uE��Gȇ���)z��p/r/�r��f�wHwI����D��z�_�����Q�-��~�����r�@}�l?t\�:=	�j��@��kH7�˝AM%�@/�r�ke��G���aU�Ki��]�ȍ;��� �H;�q9#�O`�E�O�#c��gv��~��������?uް6�B_ː�K���<~�:����>����غ]�-z�:@N�J[Ŝ���Ɏv�l>P;������cu�euɆ���ãqя�E�#~?zX҂�c�|�� Sk��~��B-� �g�+bw��/��7���B;�z�M-�18��b�`��I0�A�;�jrp�X:
 ���T���Ԟ���pe Y|�B�Al��ja�C�٤�$����(�Џ�����p�Dd-:����>�����Z�i�zW�x��L����w��~t�W��"5�Z�,� ~Ҋ�y֫������U'.��&;��X2����ں���x��U��.�#��+b@}�&:���Y,@'�L-�q�Or+! l��D�Ա���#�F���������	�˭~f@�����9���O=����3[��\;ؐ��_����bS��_��,���UM��d����s��EC��ӡ#�-��6���҂��u�&����-o�C�b�$4`en��f#�O�(�-`��ɏ ��$~y���|.��t��qp��"(�fK�-�x�Kv��V�>aP�:W�&���+���h�R����E�<����v ����{���]�LR5�2�U�?��!��q_j�%v�4a� ��m{[�'<	^��v�O1��1��_i P�P�X�A?MI�#�T�l����Y�I���k)�΂�������2k��I .�rXǚF��A�.�����:�v5`U;V&k( ?��=n�ܩ�!c���5�SK��f��aM�=W���v� �p?2m��_Y�LTI��%�����ӕ�s��Zv�E���]Z_�b�F��ދ޿ �>��	p�mX���n�����!�"T�i|��U��m��j>���&�ĉ�3#��ON|-3�Q��Ú�C��y�M�$p��:��u_Eٜȝ <t�ϟ���Ñ�n��mm�i��<�@���#V��9�1��.���E�[@�BSv6��
t"��{��}���f*�9����n)�pḡ|zl?�@�)����1����Zl�X����:�����v��+۸��?!6���v8��G+��$��l�dG�[V�`j'��2�6<�{�	�)��8}"c<C���Ρ�K\���oYڪbGg��.+>�%��5_�Z���>+W4t��o֎D���T���&��D��٦�v���q9��%�h���c��l7�1J
���DPҙ޷P{���A�;�
|����n�I+��fl�7��z����(v,�7av�}eq�*�ԤH��lb�(�%'�p�b�$QT8�D�(UBRS!$��5�ј�(�DI�51�'M;��	�96�O�O�l�,�m����)z�sKBO�;g	��dg�=�]Tleܵ/�Y~G�+8vW���6Wd��E�I.���Y&��p.�LV��������ei�-r��3ZW؅���%�$pb*�>�G�Wd��^����.T���<�>��]�D����@�g]�\T���#;���:hg��P}�B;�ѝ6!-m��:Ӻ*v0:�2����m��6��ӵ���vn�(t�	�nus���w���KS.&��(��{<W� �'�l�,�q�B���)���s�*��,ǔ��Y+��e�9>+>���	����5:�&�d:tl����>aI���E������v�l£�;����U4�+��\6�'ϲ�X�Okt�\6:�_�]ot�u���L�S��<-��yt�c��"pl�*[i����H3t�{!OY���\9�bgL�_��S�X4�B�����Q��3{��䳶���,��/�7��]�����������͢��m7�o��-ۅ~Lv��
�.+ce(�g��;�ڼwI a�R�nm��\��
ɻc����p�8b��r1c5�8B
8*:�����n�߮l�n�%Lb�C��}�;��6��h�����w���H/|��d�m�?DD����#���I|��7v�����������t�������������B����*��6�?	��>Ҿ�?�y�'�����lڗ����/Nn~�����}/����������z��o��Qz%�?rG�������/�O�c��l+XkG�2nɎ0���v�l)�ԊE�xK��X�j��H�	G�&&+x��Zg�ˢίvz��!
߶����|��f����4��5uh�ÑVF��s�"��є�0p��Ns�|]W��ʌ���J�s�]�� ��R�9,�"ch$[\�O�Ѳ���m��!iY�����I)]�M:�⤫��Sf5IƻcTc/����K;���*��������/�ml�}��v�}��m��q�p����*��q�:��}�}�����=��|:�������u�GF"���t�� ��{
��� �����?�>�9��{I����Wq�pJ��t����򟤶�?u���H����~?;�D���%�/��	jK�����}��c�ʺE��=��w��y�x���TDP�y��(*ʯ�4�U���R�+g_��TR�n�����Q�pT'�����)�B�a�?a���@��.�������j������I���~h�C�Oa���8�������Z���o��R���Y�n�W]�R��΅��Ϣ��O_����u]�D~f����u��~^W?���~�y��dV	�O����}"K�� ��e�P
�{�Ao;o����P���N�LŊ�>Wl)]e�pϷ�]c<�4�2/Z-�hb����6}�Fj�y[�D~d���W[&�����u�k��R�<!飡L�so�Y����۽O�[4W�b/L]9��ȉcWTш{6�kD))f�/M�w�D�=Y�6E�Ǳi�|{���ԣ��i�ܩJZ2b�4v�����4�����e���{Z�@����_-�����^�)Qe�����'��.���O���O�������@�eq��U�����j����?�_j����	��OD����o��[����^�['�:��=?�qU5V��7����_����_����Κ��e=�V0��)Ӑ�~R�U8�ŕm�����]��Zh��Ҋ�r��Q9�S%�1��$v���ٟ
;/E}��Һ���SY����y�ϟ�z�y'@�x>W�K�� ���i�#�>�{����eΫd�w
Q	������7�����|�M�����l+h5���['��g�I
�\1��F%G�Y�p�١�d������/��_Q��=��2P����>مP�W ���������O�_��/u��`�a�?���Gi,�X�#Y
�8�ѐ�X��}��	�pi��	�G	��)�#<4DጀG��Q�?����W��gE�Q�XH�VS��,����N���1�,Z�dym�%��`���������Èr8Y��bz�Ĵ�L�=g������$����l�HQɱ$ٽ:8�I�͈����fxRܠ���E����Y*���W���u��C�Wj��0�Sj��Ͽ��KX���Q����:�����uP��q3���D�pF�)G���N�7�Y��f��V��=���#14c�����R��v��9Gf���xrHt��(#�c"�#�q^�BgvhX�x��y�Ɔ̣*ٴ<���ｨ����"���������7��_��U`���`������W���
�B�1̝�#p�e�-��������o����w�09�Oӻ��`QI������f�!�5��3 ��� ��z�� ��G+�?T����7� ���,!���7�}B�E������͐A���n��Z��iJöX�x#҇��Nx9h0��u=i'�rι�7c����f��?G"�x�����S���==_�z�a��\.��N��p��xǁ}��;�(�z�8$�Ŋ��
����'}��g:i��&F��1ׄ���+g��/5."����O�yM6DE���;��&��/4�S�#��t&)��г�vD�٢��car��L��Y$h~�_'Z��ژͣ��c��yiu�팯��A�F>�$�2���߅	������V�����
�?�@�G�`�������W[���?���4������!���!����'��+B)��\��\��P�E��0<$}��\ץi���ِp��z�K�x�r!Ʉ�K�!,v~�P�?��E��S
~������BImj��;�P���F�x������YкF&����Cɛ��<8�fA.�d�������F>D6kB��:�M�(.ύ�z|�(o�+��g����l�z�ȑN���Qb݂������|p��?������P���ʸ���i��Ԃ��;���JB9���2��������r�a��"��������vpMP��h�;A��W����}����~�oFz�4��9�0q"/W����_T2�-��m�[��9�3���ǐ�����������1��1�?�T���w���'���˓ii��wd�I<U�jOKsd<��Bg�[�G�jhϦ�ʫ-70���q�\bu�Q2-i����(W�%�4�l#�^����~���Hz�8���9��Cv��2W��tm�����;Tl�Z�w�麇����d[T��T�FD9�z�4$Y��1לo�#)Thn�v>�bЌ�ȤT:Y��s��9ue%�8�`"����h|I�9�=�k=�]��.j�����?8߽����k�:�?���Z����P�?���	��+0���0�������y�o����%����������P:�?}	.@]P���A�/AB�_ ��!�����?��FA���Ͽ�����y����������ԁ�q���	��2P�?���B� ��������P1�C8D� ���������KA��!*�?���O=8��?JA���!�FY����$�?������W�p�j���;��?JB�l�T�������Sw���%�F�k!������J�?@��?@���A�U�� �B@����_-�����^��e������J�?@��?@�C���������/�#��
P�m�W�~o������RP+�����Q���������?����K��B-��@�a���@��2<g�dB�_�������O�z/���N��a1�!C{3�gXeg,�|�c}�ĉ�B4��O���b,�rƸ.�$��/��w��:�?AcP�W�?����2�T@�Q���ow.'�O��Fs��F��J��	j7�x�ш��G��MB�=^������P56�a>�u�燻���>L5{Y�\�i#r-���F9Z�gcH���*��QoǑ8o�$9X}<�]�oJ��ܓ:�CA�'�����{RU��5C����Y*���W���u��C�Wj��0�Sj��Ͽ��KX���Q����:���o�uj��V�jl��7z�P�,A1l_�e��g>�7�K�g�˽y0Wz�$����J��1��QD?���'��R�M{z�ݰ]̧��o[M�	<m�9J��A�n��L�P�����ߝ��oI����w��w��k�o@�`��:����������Z�4`����|�����>o��S�_����Ɉ��ޘ#[Y!2��\���_�����U�I�#8m,���u �?"�ٻej�͆t\r[�4;�ԋ�F"��mǱ��h�G�݋�4:�ȱ�#uA/���s����9�EtJ�o�z�����v��啾f�=]:�:�o�-!ׄ�{a'DrK�����!o.�q��4�h���H�<+��n(�HaYD��	��餭f��>�Ɇ�t��go9I��q̛L<"fe�6�#d}Ꝝ�y8p�vo�|,(�I@`��&
D�վp<�DigB5�ÖX6g��b���]����d��׷�׿����(�C��|��}���_��G��e��F>�����R�ٟ��D7�-ʸ�?��$�1��e�����}���/���s�'dz�e��?�0��?�)����[��n�"���h�qm��I�4�z��%��\�I�:��%��-�C�_7K����I�u땮�������'���7�������|��k��Մ�f]���չ��� �-[�%D��Ӫ�]WM��@����=�U1md���ȀRW����6�Le1�gc�=:��D�\4�sW<gN�&%�{�N�l;��Ī`�a��.��|b���-�d�=�o����]].k.DS��5/��<}�uy��45��=H���ؽ��%����b�l�Q���Tc�'_�!K��:�+�9�;�$�|,��^l��]��N�
Fcޱ�Ʉ;��!W8b�و�H���+��i�ܵ�k}���M�\�-��ǜٗV}����n���������[���G�����X��]nF��{y��}n��8�ӳ�ϐ7s	ƣ}�GC����� 6�?u�����/���J������h�w��A���C�	vӑ7غ�C�=y�Rf>w��e��^��Y� �+W�����g�����?F��W��0�������>����e\�7�?�~���W
���z���s��ʞ=��,�����pB3���s�r�??o���9���]6�c���۸�3����C���M4��y���w�����~�͎!X��h��6�t���r|Tn���5�x�N#^�'V�>͋k/�����O�g�l\L֭n+iwt�����~7�y����\�c�oF1o��q�`���N����Ҵe&�1�L��"�}?>����`��0kn��#��	C.'�K����4����}D��T��R43�֜�pN�s���ʢK6}E[���Ya��������4�������?��>�4�b(1cq������W�3ϣ\�e]�����Q��c����0�>e\������?��ǯ��Zz���PkQn�4��'OÕ�8��l�Jyߗy�D�~'~���^�\U�Q���{�ٟ�k���?�@��+u��w��P�e��Ͽ{���k	������C�����ڠ,����zW�38������x���hL�ME�׆v��d��Ϣ�|x������[�[�C��������}������|k	�D�dB��g}!�uiy�W��1��1��c�h!�n�+䣭�[�
y:�r�O_�{��޹?��m{�w�
nN�Թ���!=ur� ����֭@@| �:5����;�DgҙI���>UI�"l���{����am��׻���^��:'�xZΣ��:���֝�=����5�U���7[Da5v�C��j�
���3�ŽͬL����*�-9�rE�Zןn[�f5�R���B|^��z^�Qj
B�8��,E�+�`�7�&����ص�ao��]�/�[R�����p��lIV�����{]e!4�]Ø�:�<�j}��~U��{��o���Y�z���ve���l����Ty�2�cU���RI��R��J��g.��Ƀ�G][��2!�������+��߶������Б��C h�ȅ���!�; ��?!��?a�쿷��s�a �����_���ё��C!�������[��0��	P��A�7������{������~�,�������lȅ���ߡ�gFd��a��#�����%��3���エ� ��G��4u��?eJ������G��̕�_(��,ȉ�C]Dd���W��!��C6@��� �n�\���_�����$����۶�r��ŋ���y��AG.������C��L��P��?@����/k��B���۶�r��0�����?ԅ@D.��������&@��� ������+�`�'P��cC�?b���m�/��\�� �_�����T�����d@�?��C������`�(���y#/0��G���m��A��ԅ��?dD.���h�2I���Y�(34��u�L��ais�XbM�/���p�e�e-��2&Y&�"Gr���nݟ�<�����!�?^����2J�"�Q�>��r]��BSl��q+��L9�]����q�.�d��cݮ�q��ɝ�E���j-Nc�~���Z�vĆ?��=�nJ���NW���n��Q�tA�K!1��C��F+�%�s�!���T��f��۱kՈ�\Q��ŉ�o}�.I�Qi��Y�U糿wqQ�<g������@��Gk���y����CG��ЁR��x����[�vɃ���������ݤ�]�ס��D$��o�a�e��i[�wQm����g��Q���V{���F���mm��&�K;,�p�_K��vǷ�E��6��\���<F�j�]�cW��+9��)�N����k�G�_��_D�����~�F����/��B�A��A������h�l@����c��/��_|��ߣ���l��[v������U9rU���Og�զ?���|��&�d��W�Wv�8�z�{9�&�� 6�޸˒$��Ϣ�nQ�{cM�ۺ;)�%�>�+�|HZs�T��rb�y�ɦ� ��m���_ԺڮR
���VK�"n�s������WYü�0������k�Ѯ�ĮQyLS�������"<ڂ�s�'F_���ܬ���_i�4��6���|5��
�p:��m�RTW6jͽU�5�]�a��L��� ��RT�0�V:�0�����o���1��;p\�6dRk���k��6�K�`�Q,�B�[��O;@�GN������y%��,B�G�B��+�_<�d��O/^���>=�������&/��gA�� ���I`�����G��ԕ������bp�mq�����#��J���fB���@fOV����S��?�����������2��_& ��`H�����_.��@Fn��DB.��2�����L�f��)���>�(Qi������V��M��e\�h�l�?���}�����܏4��c����܏�ð?����~`����4��s�o�9��yx{]�o��D�zW<Q�:��$N-T��Y[v�2�a��Ƽ��Z����z�ِ���X� mt�}9�3FK��4��T�Q|u���b4��9����������v��%�Q��#M���b��i��-Ƃ2]��v=�Wp&�qՙ�:5X7�E�	Ϭ&mI��$��p���H����k���"�k.��Y��݇��T�P��>~����\�0����ߋE�Q��-��m�����GF����%�dJ.��+��(�����������B��30������E�Q7�M��m�����GD����0 �������d|���T�������k��0p\�4R[��9�T��5����Ǳl?O��Ʀ�66��s���� `O�|�(��m��?L�mh��QR*�Ap�������7mڢ7K�/�͐��h�Q���E�8Z�Q;ԋ\��J}cYVȇ��9 X��gr �4	��r z���7օE��]J��h9_�2��|ˏB������ړe�+)"�7-�?T�I9��ה�� qH�:�tkBu[��pz7������������ߧE�Q��m��m�y��"u��c�?��L����[�Z����"��K��S,m�4Y*�,eX�Ɠ����sf���s������3�����'��gÏ\�s����ø%�a:��6��Ӏji�r�뇓Y��Z��9�ʅ��?���7����.~�U��n�'"�٫��W�/|��i��~�r��C��aG���\=��ubO��\� ;�M`��ג����i��.��n�<�����#��?�@��O� &n ꦸI������G��x�/�5�#�"1'�
�b��Rl���CTk��)ዱu���ח��v8�Ҿ�W����eքS�1��ѱ_��8��:= �ǖ{�_5�����S=���B���ס59���k�G������Y���74X !�����/d@��A�����(��DC�?�-����o�����������𹱻�X] ��h�%݋�����#��?��=/�2���Ý��r�VӺ����j�a�\�4�X-j�ܢ󩌭��������q�I0Xl�m�PZ'V{h~��u�4+��mq�����K3K�<Q�z����Ui�SQ��B��	����ĸ)}�/�]K0)�NΟ���T��h����"�āl[^1
'�ʻ�HƘz~sO����ArӬfum8없�T�ڶ�l/b_i*��J�zj�l��!�#��.�%��CḶgǖ5��X������Xc�
�r�����x_m�hu�7�3�;N�U��ɿ����������w�z~^�gC�I&�����Iw�πswn�.��3-2���������Q�$�z� �k��S��RM����;�
v�/:�����r�&.=�9��� ':!~��"�k�X����;���^O7��������PR`&�������A���;~�T���O���Ƽ��O������>\|�g|c��ⸯ�?h�O�?��{��_����^=8�a��A�����q#\[��'f������3��{*fd���1r�W��Ą�T�🝫m9��'=�h:-L����o���^p�*J�û����9��H6<����_D�_��o{R������������y�*9*���_�����ӎ�?�}�?>OT$��6�κܟ�r���f��-v�av>~7O�>֒v�� �}3X�s����G��t%�9��%���sӇx�H�/ع����:����w�O�	Ý�)����|(�j{8�������6��f�˵}�µi���59������'�<_sr������^`S/���??��C�y����$K&��0��M��A,>7��3\��dU�q딒q�_\�]r�I�^�c�Z�}l�;R�US��N��$��]���y�¯?)��ݫf������?u��}~O���d                           \���c � 
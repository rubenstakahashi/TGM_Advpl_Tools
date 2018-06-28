#INCLUDE "PROTHEUS.CH"



//====================================================================================================================\
/*/{Protheus.doc}CNHValid
  ====================================================================================================================
	@description
	Valida��o do n�mero da CNH

	@author TSC681 Thiago Mota
	@version 1.0
	@since 27/06/2018

	@obs
	Calcular validade do n�mero da CNH, considerando a regra exposta na "RESOLU��O N� 192, DE 30 DE MAR�O DE 2006."

	Fonte:  http://www.denatran.gov.br/download/Resolucoes/resolucao_192_06.doc

	Art. 2�. O documento de Habilita��o ter� 2 (dois) n�meros de identifica��o nacional e 1 (um) n�mero de 
	identifica��o estadual, que s�o:

	I � o primeiro n�mero de identifica��o nacional � Registro Nacional, ser� gerado pelo sistema informatizado da Base 
	�ndice Nacional de Condutores � BINCO, composto de 9 (nove) caracteres mais 2 (dois) d�gitos verificadores de 
	seguran�a, sendo �nico para cada condutor e o acompanhar� durante toda a sua exist�ncia como condutor, n�o sendo 
	permitida a sua reutiliza��o para outro condutor.

	II � o segundo n�mero de identifica��o nacional � N�mero do Espelho da CNH, ser� formado por 8 (oito) caracteres 
	mais 1 (um) d�gito verificador de seguran�a, autorizado e controlado pelo �rg�o m�ximo executivo de tr�nsito da 
	Uni�o, e identificar� cada espelho de CNH expedida.

	a) O d�gito verificador ser� calculado pela rotina denominada de �m�dulo 11� e sempre que o resto da divis�o for 
	zero (0) ou um (1), o d�gito verificador ser� zero (0);

	III � o n�mero de identifica��o estadual ser� o n�mero do formul�rio RENACH, documento de coleta de dados do 
	candidato/condutor gerado a cada servi�o, composto, obrigatoriamente, por 11 (onze) caracteres, sendo as duas 
	primeiras posi��es formadas pela sigla da Unidade de Federa��o expedidora, facultada a utiliza��o da �ltima posi��o
	como d�gito verificador de seguran�a.

	a) O n�mero do formul�rio RENACH identificar� a Unidade da Federa��o onde o condutor foi habilitado ou realizou 
	altera��es de dados no seu prontu�rio pela �ltima vez.

	b) O Formul�rio RENACH que d� origem �s informa��es na BINCO e autoriza��o para a impress�o da CNH dever� ficar 
	arquivado em seguran�a, no �rg�o ou entidade executivo de tr�nsito do Estado ou do Distrito Federal.

	=================================================

	M�todo:
	DV m�dulo 11 corresponde ao resto da divis�o por 11 do somat�rio da multiplica��o de cada algarismo da base 
	respectivamente por 9, 8, 7, 6, 5, 4, 3, 2, 1 e 0, a partir da unidade. O resto 10 � considerado 0. 
	Seguindo a resolu��o, o resto 1 tamb�m deve ser considerado 0, por�m existem casos de CNH com d�gito 1.

	=================================================

/*/
//===================================================================================================================\
User Function CNHValid( cNumCNH )
	
	Local lRet:= .F.
	Local nX, nY
	Local cChar
	Local nAuxDig
	Local nDig
	Local cNumFim:= ""
	Local cNumValid:= ""
	Local cDig:= ""
	Local nSoma:= 0

	cNumCNH:= &(ReadVar())

	cNumCNH:= AllTrim(cNumCNH)

	If Len(cNumCNH) > 8

		For nY:= 1 To 2

			nAuxDig:= If(nY==1, 1, 0)

			For nX:= 1 To Len(cNumCNH)
				cChar:= Substr(cNumCNH, nX, 1)

				If isAlpha( cChar )
					Help(" ", 1, "ONLYNUM")
					Return lRet
				EndIf

				If nX < (Len(cNumCNH)-2)
					If nY == 1
						cNumValid+= cChar
						cNumFim+= cChar
					EndIf
					nSoma+= nAuxDig * Val(cChar)
					nAuxDig++
				EndIf
			Next nX

			// Calcula o Mod
			nDig:= nSoma % 11
			If nDig <= 1 .Or. nDig > 9
				nDig:= 0
			EndIf
			cNumValid+= cValToChar(nDig)
			cDig:= cValToChar(nDig) + cDig // O d�gito verificador da CNH � invertido
			
		Next nY

		cNumFim+= cDig

		If cNumCNH <> cNumCNH
			HELP(' ',1,"CNH Invalido" ,,"D�gito verificador da CNH inv�lido",2,0,,,,,, "")
		EndIf

	Else
		HELP(' ',1,"CNH Invalido" ,,"N�mero da CNH deve ter 11 caracteres",2,0,,,,,, "")

	EndIf

Return ( lRet )
// FIM da Funcao CNHValid
//======================================================================================================================


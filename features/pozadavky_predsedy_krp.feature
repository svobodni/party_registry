# language: cs
## ožadavek: Přijetí přihlášky
##  Jako krajský předseda
##  Abych měl pořádek v evidenci
##  Chci vyznačit přijetí přihlášky do systému

##  Scénář: Existující zájemce o členství
##    Pokud přijde listinná přihláška 
##    Když odešlu informaci o jejím přijetí
##    Pak by měl zájemce čekat na rozhodnutí KrP o přijetí

Požadavek: Seznamy členů
  Jako krajský předseda
  Abych mohl pracovat s členskou základnou
  Chci mít k dispozici seznam členů

  Scénář: Seznam členů pobočky
    Pokud jsem přihlášen do webu
    Když odešlu požadavak na seznam členů
    Pak by měl dostat seznam členů


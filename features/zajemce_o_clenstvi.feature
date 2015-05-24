# language: cs

Požadavek: Jednoduchý vznik členství
  Pro pohodlný přijímací proces
  By každý zájemce o členství
  Měl mít možnost získat informace o stavu své přihlášky

  Scénář: Zaregistrovaný, čekající na schválení bez nahrané přihlášky
    Když se přihlásím jako zájemce o členství
    Pak bych měl být přesměrován na stránku Členství
    A měl bych vidět "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva."
    A měl bych vidět "vytiskněte ji a podepsanou odešlete na adresu kanceláře"
    A neměl bych vidět "Uhraďte prosím členský příspěvek"

  Scénář: Zaregistrovaný, čekající na schválení s nahranou přihláškou
    Když se přihlásím jako zájemce o členství s nahranou přihláškou
    Pak bych měl být přesměrován na stránku Členství
    A měl bych vidět "Požádal jste o členství a čeká se na rozhodnutí krajského předsednictva."
    A neměl bych vidět "vytiskněte ji a podepsanou odešlete na adresu kanceláře"
    A neměl bych vidět "Uhraďte prosím členský příspěvek"

  Scénář: Zaregistrovaný, schválený s nahranou přihláškou, čekající na úhradu
    Když se přihlásím jako schválený zájemce o členství s nahranou přihláškou
    Pak bych měl být přesměrován na stránku Členství
    A měl bych vidět "Vaše členství bylo schváleno krajským předsednictvem."
    A neměl bych vidět "vytiskněte ji a podepsanou odešlete na adresu kanceláře"
    A měl bych vidět "Uhraďte prosím členský příspěvek"
    A měl bych vidět číslo republikového účtu

  Scénář: Řádný zaplacený člen
    Když se přihlásím jako řádný člen bez nahrané přihlášky
    A jdu na stránku Členství
    Pak měl bych vidět "Jste řádným členem se zaplacenými členskými příspěvky na tento rok."
    # FIXME: Zatim nemame naimportovane vsechny prihlasky, proto:
    A neměl bych vidět "vytiskněte ji a podepsanou odešlete na adresu kanceláře"

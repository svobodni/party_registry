# language: cs

Požadavek: Hostování v pobočce
  Pro lepší zapojení v místě skutečného bydliště
  By registrovaný uživatel
  Měl mít možnost nastavit si hostování

  Pozadí:
    Když jsem přihlášen
    A existuje pobočka "Praha 8"

  Scénář: Hostování v pobočce
    Když jdu na stránku profilu
    A v menu zvolím "Hostování"
    A zvolím hodnotu "Praha 8" z "Hostuje v pobočce"
    A odešlu formulář
    Pak bych měl být zařazen jako hostující do pobočky "Praha 8"
    A koordinátor pobočky by měl dostat notifikační email

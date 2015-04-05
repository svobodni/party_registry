# language: cs

Požadavek: Přihlašování uživatelů
  Pro využívání služeb registru
  By Nepřihlášený uživatel
  Měl být schopen se přihlásit

  Pozadí:
    Pokud existuje uživatel s přihlašovací jménem "test" a heslem "testovaciheslo"

  Scénář: Přihlášení
    Když přijdu na domovskou stránku
    A vyplním do "person_username" hodnotu "test"
    A vyplním do "heslo" hodnotu "testovaciheslo"
    A odešlu přihlašovací formulář
    Pak bych měl být úspešně přihlášen
    A měl bych vidět dashboard

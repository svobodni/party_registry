# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Country.create(id: 100, name: 'Republikové orgány', slug: 'republikove-organy', fio_account_number: '12345678')

Region.create(id: 1, name: 'Jihočeský kraj', parent_id: 100, ruian_vusc_id: 35, nuts3_id: 'CZ031', slug: 'jihocesky-kraj')

Region.create(id: 2, type: 'Region', name: 'Jihomoravský kraj', parent_id: 100, ruian_vusc_id: 116, nuts3_id: 'CZ064', slug: 'jihomoravsky-kraj')

Region.create(id: 3, type: 'Region', name: 'Karlovarský kraj', parent_id: 100, ruian_vusc_id: 51, nuts3_id: 'CZ041', slug: 'karlovarsky-kraj')

Region.create(id: 4, type: 'Region', name: 'Královéhradecký kraj', parent_id: 100, ruian_vusc_id: 86, nuts3_id: 'CZ052', slug: 'kralovehradecky-kraj')

Region.create(id: 5, type: 'Region', name: 'Liberecký kraj', parent_id: 100, ruian_vusc_id: 78, nuts3_id: 'CZ051', slug: 'liberecky-kraj')

Region.create(id: 6, type: 'Region', name: 'Moravskoslezský kraj', parent_id: 100, ruian_vusc_id: 132, nuts3_id: 'CZ080', slug: 'moravskoslezsky-kraj')

Region.create(id: 7, type: 'Region', name: 'Olomoucký kraj', parent_id: 100, ruian_vusc_id: 124, nuts3_id: 'CZ071', slug: 'olomoucky-kraj')

Region.create(id: 8, type: 'Region', name: 'Pardubický kraj', parent_id: 100, ruian_vusc_id: 94, nuts3_id: 'CZ053', slug: 'pardubicky-kraj')

Region.create(id: 9, type: 'Region', name: 'Plzeňský kraj', parent_id: 100, ruian_vusc_id: 43, nuts3_id: 'CZ032', slug: 'plzensky-kraj')

Region.create(id: 10, type: 'Region', name: 'Praha', parent_id: 100, ruian_vusc_id: 19, nuts3_id: 'CZ010', slug: 'praha')

Body.create(id: 1, name: 'Republikové předsednictvo', acronym: 'ReP', organization_id: 100, slug: 'rep')

Body.create(id: 2, name: 'Kontrolní komise', acronym: 'KK', organization_id: 100, slug: 'kk')

Body.create(id: 3, name: 'Volební komise', acronym: 'VK', organization_id: 100, slug: 'vk')

Body.create(id: 4, name: 'Rozhodčí komise', acronym: 'RK', organization_id: 100, slug: 'rk')

Body.create(id: 5, name: 'Republikový výbor', acronym: 'ReV', organization_id: 100, slug: 'rev')

Body.create(id: 6, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 1, slug: 'krp-jihocesky-kraj')

Body.create(id: 7, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 2, slug: 'krp-jihomoravsky-kraj')

Body.create(id: 8, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 3, slug: 'krp-karlovarsky-kraj')

Body.create(id: 9, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 4, slug: 'krp-kralovehradecky-kraj')

Body.create(id: 10, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 5, slug: 'krp-liberecky-kraj')

Body.create(id: 15, name: 'Krajské předsednictvo', acronym: 'KrP', organization_id: 10, slug: 'krp-praha')

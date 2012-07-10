from tahrir_api.dbapi import TahrirDatabase

db = TahrirDatabase('mysql://fedbadges:badgesareawesome@localhost/fedbadges')

badge_id = 'fossbox'
person_email = 'oddshocks@gmail.com'
person_id = hash(person_email)
issued_on = None

db.add_person(person_id, person_email)
db.add_assertion(badge_id, person_email, issued_on)

from tahrir_api.dbapi import TahrirDatabase

#Add issuer
#Add person
#if badge doesn't exist
    #Add badge
#create assertion linking badge and user

db = TahrirDatabase('mysql://fedbadges:badgesareawesome@localhost/fedbadges')

origin = 'http://foss.rit.edu/badges'
issuer_name = 'FOSS@RIT'
org = 'http://foss.rit.edu'
contact = 'remydcsi@rit.edu'

issuer_id = db.add_issuer(origin, issuer_name, org, contact)


badge_name = 'fossbox'
image = 'http://foss.rit.edu/files/fossboxbadge.png'
desc = 'Welcome to the FOSSBox. A member is you!'
criteria = 'http://foss.rit.edu'

db.add_badge(badge_name, image, desc, criteria, issuer_id)

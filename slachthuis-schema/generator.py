# INSERT INTO dbr09_g4.hulpdesk(idhulpdesk, naam, login, paswoord, slachthuis_fk)  VALUES 
# 	(0, 'aza', 'aza1', 'aza1pw', 0),
# 	(1, 'sqq', 'sqq1', 'sqq1pw', 0),
# 	(2, 'wxw', 'wxw1', 'wxw1pw', 1);

import random as R
import hashlib
import os

OUTPUT = 'insert.sql'
SCHEMA_NAME = 'dbr09_g4v2'

# files
VOORNAMEN = list(open('data/voornamen'))
ACHTERNAMEN = list(open('data/achternamen'))
STRAATNAMEN = list(open('data/straatnamen'))
PLAATSEN = list(open('data/plaatsen'))
VOERTUIGEN = dict()
VOERTUIGEN['Iveco'] = list(open('data/iveco'))
VOERTUIGEN['Mercedes'] = list(open('data/mercedes'))

def main():
	try:
	    os.remove(OUTPUT)
	except OSError:
	    pass

	row_amount_slachthuis = 100
	row_amount_administrator = row_amount_slachthuis // 20
	row_amount_voertuig = row_amount_slachthuis // 2
	row_amount_reservatie = row_amount_slachthuis * 4
	row_amount_slot = row_amount_slachthuis * row_amount_reservatie
	row_amount_leverancier = row_amount_slachthuis // 4
	
	print('generate_slachthuis')
	generate_slachthuis(row_amount_slachthuis)

	print('generate_administrator')
	generate_administrator(row_amount_administrator)

	print('generate_voertuig')
	nummerplaten = generate_voertuig(row_amount_voertuig)

	print('generate_reservatie')
	generate_reservatie(nummerplaten, 
						row_amount_reservatie, 
						row_amount_voertuig, 
						row_amount_administrator,
						row_amount_slachthuis)

	print('generate_slot')
	generate_slot(row_amount_slot, 
				row_amount_reservatie, 
				row_amount_slachthuis)

	print('generate_hulpdesk')
	generate_hulpdesk(row_amount_slachthuis)

	print('generate_leverancier')
	generate_leverancier(row_amount_leverancier)

	print('generate_hulpdesk_past_reservatie_aan')
	generate_hulpdesk_past_reservatie_aan(row_amount_slachthuis, row_amount_reservatie)

	print('generate_leverancier_maakt_reservatie')
	generate_leverancier_maakt_reservatie(row_amount_reservatie, row_amount_leverancier)

	print('generate_loskade')
	generate_loskade(row_amount_slachthuis)

	print('generate_loskade_bij_voertuig')
	generate_loskade_bij_voertuig(row_amount_slachthuis, nummerplaten)





def generate_slachthuis(row_amount):
	cols = '(idSlachthuis, Adres , Openingsuren , Sluitingsdagen , Capaciteit, Naam)'
	tn = 'Slachthuis'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		
		rows.append(gen_row([str(row_id), 
							random_adres(), 
							random_openingsuren(), 
							random_sluitingsdagen(), 
							str(R.randint(25, 500)), 
							quote('SLACHTHUIS ' + R.choice(ACHTERNAMEN).strip()[:45])\
							]))
	gensql(header, rows)

def generate_administrator(row_amount):
	cols = '(idAdministrator, Login , Paswoord, Naam)'
	tn = 'Administrator'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		
		naam = random_naam()
		rows.append(gen_row([str(row_id), 
							quote(usernameify(naam)[:20]), 
							quote(paswoordify(naam)[:45]), 
							quote(naam[:20])\
							]))
	gensql(header, rows)

def generate_voertuig(row_amount):
	cols = '(Nummerplaat, Aankomsttijd, Type, Merk)' # TODO id toevoegen ?
	tn = 'Voertuig'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	nummerplaten = list()
	for row_id in range(0, row_amount):
		
		voertuig = random_voertuig()
		nummerplaten.append(random_nummerplaat())
		rows.append(gen_row([nummerplaten[-1], 
							random_time(), 
							voertuig[1], 
							voertuig[0]\
							]))
	gensql(header, rows)
	return nummerplaten

def generate_reservatie(nummerplaten, row_amount, row_amount_voertuig, row_amount_administrator, row_amount_slachthuis):
	cols = '(idReservatie, Datum , Uur, Administrator_idAdministrator, Voertuig_idVoertuig, Slachthuis_idSlachthuis, Voertuig_Nummerplaat)'
	tn = 'Reservatie'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		
		voertuig_id = R.randint(0, row_amount_voertuig - 1)
		rows.append(gen_row([str(row_id), 
							random_date(), 
							random_time(), 
							str(R.randint(0, row_amount_administrator - 1)),
							str(voertuig_id),
							str(R.randint(0, row_amount_slachthuis - 1)),
							nummerplaten[voertuig_id] \
							]))
	gensql(header, rows)

def generate_slot(row_amount, row_amount_reservatie, row_amount_slachthuis):
	cols = '(Slot_nr, Grootte, Reservatie_idReservatie, Slachthuis_idSlachthuis)'
	tn = 'Slot'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		rows.append(gen_row([str(row_id),
							str(R.randint(5, 30)),
							str(R.randint(0, row_amount_reservatie - 1)),
							str(R.randint(0, row_amount_slachthuis - 1))\
							]))
	gensql(header, rows)

def generate_hulpdesk(row_amount):
	cols = '(IdHulpdesk, Naam , Login , Paswoord , Slachthuis_FK)'
	tn = 'Hulpdesk'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		naam = random_naam()
		rows.append(gen_row([str(row_id),
							quote(naam[:20]),
							quote(usernameify(naam)[:20]),
							quote(paswoordify(naam)[:45]),
							str(row_id)\
							]))
	gensql(header, rows)

def generate_leverancier(row_amount):
	cols = '(idLeverancier, Naam , Login , Paswoord)'
	tn = 'Leverancier'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for row_id in range(0, row_amount):
		naam = random_naam()
		rows.append(gen_row([str(row_id),
							quote(naam[:20]),
							quote(usernameify(naam)[:20]),
							quote(paswoordify(naam)[:45])\
							]))
	gensql(header, rows)

def generate_hulpdesk_past_reservatie_aan(row_amount_hulpdesk, row_amount_reservatie):
	cols = '(Hulpdesk_IdHulpdesk, Reservatie_idReservatie, Datum , Reden_van_aanpassing, Uur)'
	tn = 'Hulpdesk_Past_Reservatie_Aan'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	# random hoeveelheid aanpassignen we gaan er van uit dat maar een klein % aangepast wordt ? 
	for row_id in range(0, R.randint(row_amount_reservatie // 40, row_amount_reservatie // 20)):
		rows.append(gen_row([str(R.randint(0, row_amount_hulpdesk - 1)),
							str(R.randint(0, row_amount_reservatie - 1)),
							random_date(),
							random_zin('waren'),
							random_time()\
							]))
	gensql(header, rows)

def generate_leverancier_maakt_reservatie(row_amount_reservatie, row_amount_leverancier):
	cols = '(Leverancier_idLeverancier, Reservatie_idReservatie, Datum , Opmerkingen)'
	tn = 'Leverancier_Maakt_Reservatie'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	for reservatie_id in range(0, row_amount_reservatie):
		rows.append(gen_row([str(R.randint(0, row_amount_leverancier - 1)),
							str(reservatie_id),
							random_date(),
							random_zin('zijn')\
							]))
	gensql(header, rows)

def generate_loskade(row_amount_slachthuis):
	cols = '(Loskade_nr, Grootte, Aantal, Slachthuis_idSlachthuis)'
	tn = 'Loskade'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	loskades = R.randint(1, 5)
	for slachthuis_id in range(0, row_amount_slachthuis):
		rows.append(gen_row([str(slachthuis_id),
							str(R.randint(1, 10)),
							str(R.randint(1, 5)),
							str(slachthuis_id)\
							]))
	gensql(header, rows)

def generate_loskade_bij_voertuig(row_amount_slachthuis, nummerplaten):
	cols = '(Loskade_Nummer, Datum , Voertuig_Nummerplaat)'
	tn = 'Loskade_Bij_Voertuig'
	header = gen_header(SCHEMA_NAME, tn, cols)
	rows = list()
	nmrp_index = 0
	for row_id in range(0, row_amount_slachthuis):
		rows.append(gen_row([
							str(row_id),
							random_date(),
							nummerplaten[nmrp_index]\
							]))
		if nmrp_index >= len(nummerplaten) - 1:
			nmrp_index = 0
		else:
			nmrp_index += 1

	gensql(header, rows)


## UTLITIES

def gensql(header, rows):
	values_string = ",\n".join(rows) + ";\n" # !! last , becomes ;
	with open(OUTPUT, 'a') as insert_query:
		insert_query.write(header)
		insert_query.write(values_string)
		insert_query.write("\n\n")

def gen_header(schema_name, table_name, columns):
	# INSERT INTO dbr09_g4.hulpdesk(idhulpdesk, naam, login, paswoord, slachthuis_fk)  VALUES 
	return 'INSERT INTO ' + schema_name + '.' + table_name + columns + " VALUES\n"

def gen_row(values):
	return '(' + ', '.join(values) + ')'

def quote(s):
	return "\'" + s + "\'"	

## RANDOM GENERATORS

def random_naam():
	return R.choice(VOORNAMEN).strip() + ' ' + R.choice(ACHTERNAMEN).strip() # strip omdat de namenlijsten 'vuil' zijn

def usernameify(naam):
	prefix = ['', 'Mr.', 'DarkL0rd', 'WizardKING', 'Vettige']
	suffix = ['', 'tje', '007', 'SLACHTER', '123']
	return R.choice(prefix) + naam + R.choice(suffix)


def paswoordify(naam):
	pw = naam.lower().replace('o', '0').replace('i', '1').replace('a', '4').replace('e', '3')
	pw += str(R.randint(0, 100))
	pw = hashlib.sha1(pw.encode()).hexdigest()
	return pw

def random_adres():
	adres = R.choice(STRAATNAMEN).strip() + ' '
	adres += str(R.randint(1, 150)) + ', '
	adres += str(R.randint(1000, 9000)) + ' '
	adres += R.choice(PLAATSEN).strip()
	return quote(adres[:45])

def random_openingsuren():
	return quote(str(R.randint(6, 9)) + '-' + str(R.randint(18, 21)))

def random_sluitingsdagen():
	# dit maakt een string waarbij elke mogelijke sluitingsdag 50% (choice true/false) kans heeft om voor te komen
	return quote(''.join([x for x in ['ma', 'za', 'zo'] if R.choice([True, False])]))

def random_voertuig():
	merk = R.choice(list(VOERTUIGEN.keys()))
	typ = R.choice(VOERTUIGEN[merk]).strip()
	return [quote(merk[:45]), quote(typ[:45])]

def random_nummerplaat():
	alfa = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
	def nmrp_symbool():
		return R.choice([R.choice(alfa), str(R.randint(0, 9))])
	
	return quote(''.join(nmrp_symbool() for x in range(6)))


def random_time():
	t = str(R.randint(0, 23)).zfill(2) + ':' + str(R.randint(0, 59)).zfill(2) + ':' + str(R.randint(0, 59)).zfill(2)
	return quote(t)

def random_date():
	y = str(R.randint(1990, 2018))
	m = str(R.randint(1, 12))
	d = str(R.randint(1, 12)) # TODO checken of we europees of amerkiaans zijn
	return quote(y + '-' + m + '-' + d)

def random_zin(woord):
	synoniemen = ['Akelig','Ambetant','Ergeniswekkend','Ergerlijk','Ergernis gevend',
				'Ergernisgevend','Ergerniswekkend', 'Hinderlijk','Lastig','Niet leuk',
				'Op de zenuwen werkend','Prikkelend','Storend','Tergend','Treiterend','Vervelend']
	beesten = ['Koeien', 'Schapen', 'Zwijnen', 'Kippen', 'Kalkoenen']
	zin = 'De ' + R.choice(beesten) + ' ' + woord + ' ' + R.choice(synoniemen) + '.'
	return quote(zin[:100])



if __name__ == '__main__':
	main()
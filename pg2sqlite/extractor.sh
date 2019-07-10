pg_dump postgresql://r0599128@databanken.ucll.be:54321/basis_rdbms?sslmode=prefer  \
	--column-inserts \
	# --no-owner \
	# --no-privileges \
	# --section=post-data \
	# -T tennis.spelers_l \
	# -T tennis.spelers_xl \
	# -T tennis.spelers_xxl \
	# -T tennis.spelers_xxxl \
	# -n tennis \
	-t spelers
	# -f tennis-postdata.sql

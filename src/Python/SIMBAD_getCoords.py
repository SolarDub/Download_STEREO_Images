import warnings
warnings.filterwarnings('ignore')
import sys
import astropy
from astroquery.simbad import Simbad

# Perform query on star (name passed by single argument)
t = Simbad.query_object(str(sys.argv[1]))

# Output RA and DEC values from query output table
sys.exit([t['RA'][0],t['DEC'][0]])

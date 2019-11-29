import psycopg2 as ps
import psycopg2.extras
import re
from elasticsearch import Elasticsearch
from datetime import datetime

class SqlReader:
    def __init__(self, con):
        self.con = con

    def __del__(self):
        if self.con is not None:
            con.close()

    def fetch_as_dict(self, sql, params = None):
        cur = self.con.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute(sql)
        rows = cur.fetchall()
        cur.close()
        return rows

DB_HOST='server2053.cs.technik.fhnw.ch'
DB_PORT = 5432
DB_DBNAME = 'warenkorb_db' # or 'warenkorb_db'
DB_USERNAME = 'db_user' 
DB_PASSWORD = 'db_user_pw'

sql_con = ps.connect(host=DB_HOST, database=DB_DBNAME, user=DB_USERNAME, password=DB_PASSWORD)
reader = SqlReader(sql_con)
sql = 'SELECT * FROM product p'
products = reader.fetch_as_dict(sql)

docs = []
for product in products:
    name = product['product_name']
    is_organic = name.tolower().find('Organic') >= 0 
        or name.tolower().find('bio ') >= 0 
        or name.tolower().find('bio ') >= 0
    regex = re.compile('(organic|\wbio|bio\w)')
    stripped_name = name.replace("")
    doc = {
        'original_name': name,
        'stripped_name': 
        'organic': product['product_name']
    }
    docs.append((product['product_id'], doc))



es_con = Elasticsearch()

for doc in docs:
    res = es_con.index(index="products", doc_type='product', id=doc[0], body=doc[1])

print(len(docs))

search = es_con.search(index="products", body={'query': {'match': {'product_name': 'Banana'}}})

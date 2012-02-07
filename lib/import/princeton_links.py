from nltk.corpus.reader.wordnet import WordNetError
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, ForeignKey
#import psycopg2
from nltk.corpus import wordnet
from sqlalchemy.orm.session import sessionmaker
from sqlalchemy.schema import Sequence


engine = create_engine('postgresql://localhost/andreord_development', echo=False)
Session = sessionmaker(bind=engine)
metadata = MetaData(bind=engine)
alignments = Table('alignments', metadata,
                   Column('id', Integer, Sequence('alignments_id_seq'), primary_key=True),
                   Column('source', String),
                   Column('lemma', String),
                   Column('definition', String),
                   Column('synonyms', String),
                   Column('key', String),
                   Column('relation_type_name', String),
                   Column('syn_set_id', ForeignKey('syn_sets.id'))
)
session = Session()

f=open('/Users/anders/code/andreord/lib/import/dan_net_data/relations.csv')

for line in f.readlines():
    record = line.split("@")
    if record[2] in ('eq_has_synonym', 'eq_has_hyponym', 'eq_has_hyperonym'):
        source, target = record[0], record[3]
        if target.startswith("EN"):
            pass
        else:
            try:
                lemma = wordnet.lemma_from_key(target)
                synset = lemma.synset
                ins = alignments.insert().values(source='wordnet30',
                                           lemma=lemma.name,
                                           definition=synset.definition,
                                           synonyms="; ".join(synset.lemma_names),
                                           key=target,
                                           relation_type_name=record[2],
                                           syn_set_id=int(source)*1000)
                engine.execute(ins)
            except WordNetError as e:
                print e


#sql = ("UPDATE syn_sets SET hyponym_count = %d WHERE id = %d" % (G.node[node]['branch_count'], db_node))
#print sql
#if not cur.execute(sql):
#print cur.statusmessage
#conn.commit()

import psycopg2
import networkx as nx
#from networkx.traversal import dfs_postorder_nodes

conn = psycopg2.connect("dbname=andreord_development user=postgres")
cur = conn.cursor()

#cur.execute("SELECT syn_set_id, target_syn_set_id " +
#             "FROM relations r " +
#             "JOIN relation_types rt ON r.relation_type_id = rt.id "
#             "WHERE rt.name = %s ", ('has_hyperonym',))
#top_node = 20633000L

f=open('/Users/anders/code/andreord/lib/import/dan_net_data/relations.csv')

# DELETEd this:
#  2819377 |              258 |                    |   48335000 |           |                     |          15592000
# 2617606 |              279 |                    |   15592000 |           | Inherited from synset with id 15567 ({brugsgenstand_1; brugsting_1}) |          48335000


G=nx.DiGraph()
#for record in cur:
#    src, target = record[0], record[1]
#    G.add_edge(target, src)

#for node in nx.dfs_postorder(G, 20633000L):
#    counts = [
#        G.node[succ]['branch_count']
#        for succ in G.successors(node)]
#    G.node[node]['branch_count'] = sum(counts) + 1



for line in f.readlines():
    record = line.split("@")
    if record[2] == 'has_hyperonym':
        source, target = record[0], record[3]
        G.add_edge(target, source)

if nx.is_strongly_connected(G):
    print "WARNING: Graph is strongly connected"


for component in nx.strongly_connected_components(G):
    if len(component) > 1:
        print component

G.add_edge('20633', '48174')
G.add_edge('20633', '48920')

dangling_nodes = ['8884', '18125']
G.remove_nodes_from(dangling_nodes)

for node in nx.traversal.dfs_postorder_nodes(G, "20633"):
    counts = [
        G.node[succ]['branch_count']
        for succ in G.successors(node)]
    G.node[node]['branch_count'] = sum(counts) + 1

for node in G.nodes():
    db_node = int(node) * 1000
    if 'branch_count' not in G.node[node]:
        print "{} is missing branch_count".format(node)
    else:
        sql = ("UPDATE syn_sets SET hyponym_count = %d WHERE id = %d" % (G.node[node]['branch_count'], db_node))
#    print sql
        if not cur.execute(sql):
            print cur.statusmessage

conn.commit()
#degree_2 = [node for node in G if G.degree(node) > 1]


#for component in nx.connected_components(nx.Graph(G)):
    #print component

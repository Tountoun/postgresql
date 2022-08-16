import psycopg2 as ps
conn, cur = None, None

try:
    # Connexion à la base de données
    conn = ps.connect(
        database = "test",
        user = "postgres",
        password = "tilltates",
        port = 5432,
        host = "localhost"
    )
    # Commit automatique
    conn.autocommit = True

    cur = conn.cursor() 
    create_table = "create table if not exists produit(id serial primary key, p_name varchar(20) not null, prix numeric(5,2) default 0.0);"

    insert_script = "insert into client(name, age) values('Abel', 20);"
    select_script = "select * from client;"

    condition_script = "select * from client where age > 17;"
    cur.execute(condition_script);
    
    # Recuperer la premiere ligne du resultat de la requete
    res = cur.fetchone(); 
    # REcuperer le resultat sous forme de liste
    res = cur.fetchall();
    #print(res)
    res_dict = {}
    for i, ele in enumerate(res):
        res_dict[i] = ele
    #print("Tous les personnes qui ont une age superieur ou egale a 19")
    #print(res_dict)
    #print("Insertion avec succès")

    # Insertion multiple dans une table
    mul_insert_script = "insert into produit(p_name, prix) values (%s, %s);"
    list_values = [
        ('Spaghetti', 400),
        ('Sardines', 350),
        ('Riz Gino', 1400),
        ('Savon Flash', 350),
        ('Pils', 550),
        ('Mayonnaise Remia', 2200)
    ]
    #cur.executemany(mul_insert_script, list_values) 
    select_produit = "select * from produit;"
    cur.execute(select_produit)
    res = cur.fetchall()
    [print(ele) for ele in res]
except Exception as error:
    print(error)
finally:
    cur.close() if cur == None else ""
    # Fermeture de la connexion
    conn.close() if conn == None else ""
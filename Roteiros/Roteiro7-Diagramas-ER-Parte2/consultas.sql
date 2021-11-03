-- 1º Consulta

"""
Consulta que retorna uma lista com as equipes e a quantidade de jogadores
de cada uma dessas equipes em ordem decrescente. Para essa consulta
primeiramente foi preciso saber quais jogadores pertencem a cada equipe,
para fazer isso bastava utilizar o atributo do jogador que identificava a qual
equipe ele pertencia, ou seja, o (equipe_id), depois disso foi preciso agrupar
os jogadores por suas equipes, usando o group by, e finalmente realizar a
contagem de tuplas, usando o count, que cada agrupamento gerou, e para
finalizar bastava especificar a ordem do resultado como decrescente.
"""

SELECT e.nome equipe, count(*) num_jogador
FROM JOGADOR j INNER JOIN EQUIPE e ON j.equipe_id = e.id
GROUP BY e.id
ORDER BY count(*) DESC;

------------------------------------------------------------------------------------------

-- 2º Consulta

"""
Consulta que retorna a lista de jogos com o nome das equipes que jogaram, a
quantidade de gols de cada uma dessas equipes e qual foi a equipe vencedora. 
Para essa consulta primeiramente foi preciso saber quais equipes
jogaram cada jogo, para fazer isso bastava utilizar o atributo (equipe1_id) e
(equipe2_id) da entidade jogo e depois relacionar com a entidade equipe,
diferenciando a equipe1 da equipe2 na consulta, depois com esse resultado
bastava saber qual equipe venceu, para isso foi utilizado o case onde foi
comparado qual equipe tinha um maior número de gols pois essa seria a
vencedora, depois disso bastava retornar o resultado.
"""

SELECT e1.nome equipe1, e2.nome equipe2, j.equipe1_gols,
j.equipe2_gols,
    CASE
        WHEN j.equipe1_gols > j.equipe2_gols then e1.nome
        WHEN j.equipe1_gols < j.equipe2_gols then e2.nome
        ELSE 'empate'
    END AS vencedor
FROM JOGO j INNER JOIN EQUIPE e1 ON j.equipe1_id = e1.id
AND j.equipe2_id <> e1.id INNER JOIN EQUIPE e2 ON
j.equipe1_id <> e2.id AND j.equipe2_id = e2.id;

------------------------------------------------------------------------------------------

-- 3º Consulta

"""
Consulta que retorna uma lista com os jogadores que jogaram os jogos na
posição de pivô, contendo o nome dos jogadores, o id do jogo e a equipe do
jogador, em ordem decrescente. Para essa consulta primeiramente foi preciso
saber quais eram os jogadores que participaram dos jogos bem como as
equipes desses jogadores, para fazer isso bastava utilizar o atributo da
entidade jogador_jogo que identifica o jogador, ou seja, o (jogador_cpf) e
depois relacionar esses jogadores as suas equipes usando o atributo
(quipe_id) de jogador, com o resultado pronto bastava filtrar a consulta para
retornar apenas os jogadores que jogaram na posição de pivô e para finalizar
especificar a ordem do resultado como decrescente
"""

SELECT jg.jogo_id, jo.nome jogador, e.nome equipe
FROM JOGADOR jo INNER JOIN JOGADOR_JOGO jg ON jo.cpf =
jg.jogador_cpf INNER JOIN EQUIPE e ON jo.equipe_id = e.id
WHERE jg.posicao = 'Pivô'
ORDER BY jg.jogo_id;

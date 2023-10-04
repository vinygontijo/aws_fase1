bronze_dict = {
    "customers":["id","nome","sexo","nascimento","profissao"],
    "credit_score":["customer_id","nome","provedor","credit_score"],
    "flight":["customer_id","aeroporto","linha_aerea"],
    "vehicle":["customer_id","modelo","fabricante","ano_veiculo"]
}

silver_dict = {
    "customers":"""
                    select 
                        id, 
                        nome, 
                        sexo, 
                        nascimento, 
                        profissao,
                        floor(datediff(now(),nascimento)/365.25) as idade, 
                        case when floor(datediff(now(),nascimento)/365.25) > 60 then 'idoso'
                             when floor(datediff(now(),nascimento)/365.25) > 30 then 'adulto'
                             when floor(datediff(now(),nascimento)/365.25) > 15 then 'joven'
                             else 'crianca' end as categoria_idade
                    from customers
                """,
                
    "credit_score":"""
                        select
                            customer_id as id_cliente,
                            nome,
                            provedor,
                            credit_score as pontuacao,
                            case when credit_score > 800 then 'Altíssimo'
                                 when credit_score > 550 then 'Alto'
                                 when credit_score > 350 then 'Médio'
                                 when credit_score > 150 then 'Baixo'
                                 else 'Baixíssimo' end as categoria_credito
                        from credit_score
                """,

    "flight":"""
                select
                    customer_id as id_cliente,
                    aeroporto,
                    linha_aerea
                from flight
            """,

    "vehicle":"""
                    select
                        customer_id as id_cliente,
                        modelo,
                        fabricante,
                        ano_veiculo,
                        case when ano_veiculo > 2022 then 'Carro do ano'
                                 when ano_veiculo > 2010 then 'Carro recente'
                                 when ano_veiculo > 2000 then 'Carro não tão recente'
                                 else 'Carro Antigo' end as categoria_veiculo
                    from vehicle
            """
}

gold_list = ["mysql/owshqmysql/customers", "mysql/owshqmysql/credit_score", "mysql/owshqmysql/flight", "mysql/owshqmysql/vehicle"]


gold_dict = {
    "customer_flights":"""
                    select distinct
                        c.id, 
                        c.nome, 
                        c.sexo, 
                        c.nascimento, 
                        c.profissao, 
                        c.idade,
                        f.aeroporto,
                        f.linha_aerea
                    from customers as c
                    left join flight as f on f.id_cliente = c.id
                """,
                
    "customers":"""
                        select distinct
                            c.id, 
                            c.nome, 
                            c.sexo, 
                            c.nascimento, 
                            c.profissao, 
                            c.idade,
                            cre.provedor,
                            cre.pontuacao,
                            v.modelo,
                            v.fabricante,
                            v.ano_veiculo,
                            v.categoria_veiculo
                        from customers as c
                        left join vehicle as v on v.id_cliente = c.id
                        left join credit_score as cre on cre.id_cliente = c.id
                """
}
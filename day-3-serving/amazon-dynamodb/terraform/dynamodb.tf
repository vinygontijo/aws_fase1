# module "dynamodb_table" {
#   source   = "terraform-aws-modules/dynamodb-table/aws"

#   for_each = toset(["customers", "customer_flights"])

#   name     = each.key
#   hash_key = "id"

#   attributes = [
#     {
#       name = "id"
#       type = "N"
#     }
    # ,
    # {
    #   name = "nome"
    #   type = "S"
    # },
    # {
    #   name = "nascimento"
    #   type = "S"
    # },
    # {
    #   name = "profissao"
    #   type = "S"
    # },
    # {
    #   name = "idade"
    #   type = "N"
    # },
    # {
    #   name = "provedor"
    #   type = "S"
    # },
    # {
    #   name = "pontuacao"
    #   type = "S"
    # },
    # {
    #   name = "modelo"
    #   type = "N"
    # },
    # {
    #   name = "fabricante"
    #   type = "S"
    # },
    # {
    #   name = "ano_veiculo"
    #   type = "S"
    # },
    # {
    #   name = "categoria_veiculo"
    #   type = "S"
    # },
#   ]
# }
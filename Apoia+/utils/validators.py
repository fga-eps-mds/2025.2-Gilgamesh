import re
from django.core.exceptions import ValidationError

def validate_cpf(cpf):
    """
    Valida se o CPF é válido matematicamente.
    Retorna True se válido, False se inválido.
    """
    if not cpf:
        return False
        
    # Remove caracteres não numéricos
    cpf = ''.join(filter(str.isdigit, cpf))

    if len(cpf) != 11:
        return False
    
    # Verifica se todos os dígitos são iguais (ex: 111.111.111-11)
    if cpf == cpf[0] * 11:
        return False

    # Cálculo do primeiro dígito verificador
    soma = sum(int(cpf[i]) * (10 - i) for i in range(9))
    primeiro_digito = (soma * 10 % 11) % 10

    if int(cpf[9]) != primeiro_digito:
        return False

    # Cálculo do segundo dígito verificador
    soma = sum(int(cpf[i]) * (11 - i) for i in range(10))
    segundo_digito = (soma * 10 % 11) % 10

    if int(cpf[10]) != segundo_digito:
        return False

    return True

def validate_cnpj(cnpj):
    """
    Valida se o CNPJ é válido matematicamente.
    Retorna True se válido, False se inválido.
    """
    if not cnpj:
        return False

    cnpj = ''.join(filter(str.isdigit, cnpj))

    if len(cnpj) != 14:
        return False
    
    if cnpj == cnpj[0] * 14:
        return False

    # Pesos para o cálculo do primeiro dígito
    pesos_1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    soma = sum(int(cnpj[i]) * pesos_1[i] for i in range(12))
    resto = soma % 11
    primeiro_digito = 0 if resto < 2 else 11 - resto

    if int(cnpj[12]) != primeiro_digito:
        return False

    # Pesos para o cálculo do segundo dígito
    pesos_2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    soma = sum(int(cnpj[i]) * pesos_2[i] for i in range(13))
    resto = soma % 11
    segundo_digito = 0 if resto < 2 else 11 - resto

    if int(cnpj[13]) != segundo_digito:
        return False

    return True

def validate_strong_password(password):
    """
    Valida se a senha tem no mínimo 8 caracteres, letras e números.
    """
    if not password:
        return False
    if len(password) < 8:
        return False
    if not re.search(r'[A-Za-z]', password): # Tem letras?
        return False
    if not re.search(r'\d', password): # Tem números?
        return False
    return True

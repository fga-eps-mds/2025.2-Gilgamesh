import pytest
from rest_framework.exceptions import ValidationError
from autenticacao.serializers import UsuarioSerializer
from autenticacao.models import Usuario
from utils.validators import validate_cpf, validate_cnpj, validate_strong_password

@pytest.mark.django_db
class TestSerializerCoverage:
    """
    Testes de Integração focados em cobrir 100% das linhas do autenticacao/serializers.py.
    Boas Práticas: 
    1. Separation of Concerns: Testamos regras de negócio (tipos de usuário) separadas de regras matemáticas.
    2. Edge Cases: Testamos inputs que parecem válidos (formato) mas são inválidos (lógica).
    """

    def test_create_happy_path_voluntario(self):
        """Cobre o sucesso de criação e validação de CPF."""
        cpf_valido = "52998224725"
        data = {
            "nome": "Hero", "email": "hero@test.com", "password": "SenhaForte123",
            "tipo_usuario": "voluntario", "cpf": cpf_valido
        }
        serializer = UsuarioSerializer(data=data)
        assert serializer.is_valid()
        serializer.save()
        assert validate_cpf(data['cpf']) is True

    def test_create_happy_path_ong(self):
        """Cobre o sucesso de criação e validação de CNPJ."""
        cnpj_valido = "11111111000191"
        data = {
            "nome": "ONG", "email": "ong@test.com", "password": "SenhaForte123",
            "tipo_usuario": "ong", "cnpj": cnpj_valido
        }
        serializer = UsuarioSerializer(data=data)
        assert serializer.is_valid()
        serializer.save()
        assert validate_cnpj(data['cnpj']) is True

    def test_ong_sem_cnpj(self):
        """Erro: ONG sem CNPJ."""
        data = {"nome": "ONG", "email": "ong@t.com", "password": "SenhaForte123", "tipo_usuario": "ong"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_ong_com_cpf(self):
        """Erro: ONG com CPF."""
        data = {"nome": "ONG", "email": "ong2@t.com", "password": "SenhaForte123", "tipo_usuario": "ong", "cnpj": "11111111000191", "cpf": "123"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors

    def test_ong_cnpj_invalido_matematica(self):
        """
        CRÍTICO (Cobre linha 38): Formato correto (14 dígitos), mas matemática inválida.
        Isso força o serializer a passar pelas checagens iniciais e falhar na chamada do validate_cnpj.
        """
        data = {
            "nome": "ONG Bad", "email": "bad@ong.com", "password": "SenhaForte123",
            "tipo_usuario": "ong", "cnpj": "00000000000000"
        }
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_voluntario_sem_cpf(self):
        """Erro: Voluntário sem CPF."""
        data = {"nome": "Vol", "email": "v@t.com", "password": "SenhaForte123", "tipo_usuario": "voluntario"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors

    def test_voluntario_com_cnpj(self):
        """Erro: Voluntário com CNPJ."""
        data = {"nome": "Vol", "email": "v2@t.com", "password": "SenhaForte123", "tipo_usuario": "voluntario", "cpf": "52998224725", "cnpj": "123"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_voluntario_cpf_invalido_matematica(self):
        """
        CRÍTICO (Cobre linha 48): Formato correto (11 dígitos), mas matemática inválida.
        Isso força o serializer a passar pelas checagens iniciais e falhar na chamada do validate_cpf.
        """
        data = {
            "nome": "Vol Bad", "email": "bad@vol.com", "password": "SenhaForte123",
            "tipo_usuario": "voluntario", "cpf": "11111111111"
        }
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors
    
    def test_senha_fraca(self):
        """Erro: Senha Fraca."""
        data = {"nome": "H", "email": "h@t.com", "password": "123", "tipo_usuario": "voluntario", "cpf": "52998224725"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "password" in serializer.errors


class TestValidatorsMath:
    """
    Testes Unitários da Lógica Pura (utils/validators.py).
    Objetivo: White-box testing para garantir coverage de branches (if/else).
    """

    # --- CPF ---
    def test_cpf_none(self): 
        assert validate_cpf(None) is False
    
    def test_cpf_vazio(self): 
        assert validate_cpf("") is False
    
    def test_cpf_tamanho(self): 
        assert validate_cpf("123") is False
    
    def test_cpf_iguais(self): 
        assert validate_cpf("11111111111") is False
    
    def test_cpf_falha_primeiro_digito(self): 
        # Base: 111.444.777 -> Digitos corretos seriam 35.
        # Passamos 11 -> Falha logo no primeiro.
        assert validate_cpf("11144477711") is False

    def test_cpf_falha_apenas_segundo_digito(self):
        # CRÍTICO (Cobre linha 27): 
        # Base: 111.444.777 -> 1º Digito é 3.
        # Passamos '38'. O '3' passa na primeira validação. O '8' falha na segunda.
        assert validate_cpf("11144477738") is False

    def test_cpf_success(self): 
        # Base: 111.444.777 -> Digitos corretos 35.
        assert validate_cpf("11144477735") is True

    # --- CNPJ ---
    def test_cnpj_none(self): 
        assert validate_cnpj(None) is False

    def test_cnpj_vazio(self): 
        assert validate_cnpj("") is False

    def test_cnpj_tamanho(self): 
        assert validate_cnpj("123") is False

    def test_cnpj_digitos_iguais(self): 
        assert validate_cnpj("22222222222222") is False

    def test_cnpj_primeiro_digito_errado(self): 
        assert validate_cnpj("11111111000101") is False

    def test_cnpj_segundo_digito_errado(self): 
        assert validate_cnpj("11111111000190") is False

    def test_cnpj_success(self): 
        assert validate_cnpj("11111111000191") is True

    # --- SENHA ---
    def test_pass_none(self): 
        assert validate_strong_password(None) is False

    def test_pass_short(self): 
        assert validate_strong_password("Ab1") is False

    def test_pass_no_letter(self): 
        assert validate_strong_password("12345678") is False

    def test_pass_no_number(self): 
        assert validate_strong_password("ABCDEFGH") is False

    def test_pass_success(self): 
        assert validate_strong_password("SenhaForte1") is True

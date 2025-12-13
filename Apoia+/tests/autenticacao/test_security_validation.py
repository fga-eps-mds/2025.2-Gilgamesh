import pytest
from faker import Faker
from rest_framework.exceptions import ValidationError
from autenticacao.serializers import UsuarioSerializer
from autenticacao.models import Usuario
from utils.validators import validate_cpf, validate_cnpj, validate_strong_password

@pytest.mark.django_db
class TestSerializerCoverage:
    """
    Testes de Integração (Serializer + Validator).
    """

    def test_create_happy_path_voluntario(self):
        cpf_valido = "52998224725"
        data = {
            "nome": "Hero", 
            "email": "hero@test.com", 
            "password": "SenhaForte123",
            "tipo_usuario": "voluntario", 
            "cpf": cpf_valido,
            "uf": "DF"
        }
        serializer = UsuarioSerializer(data=data)
        assert serializer.is_valid(), f"Erros: {serializer.errors}"
        serializer.save()
        assert validate_cpf(data['cpf']) is True

    def test_create_happy_path_ong(self):
        cnpj_valido = "11111111000191"
        data = {
            "nome": "ONG", 
            "email": "ong@test.com", 
            "password": "SenhaForte123",
            "tipo_usuario": "ong", 
            "cnpj": cnpj_valido,
            "uf": "SP"
        }
        serializer = UsuarioSerializer(data=data)
        assert serializer.is_valid(), f"Erros: {serializer.errors}"
        serializer.save()
        assert validate_cnpj(data['cnpj']) is True

    def test_ong_sem_cnpj(self):
        data = {"nome": "ONG", "email": "ong@t.com", "password": "SenhaForte123", "tipo_usuario": "ong", "uf": "RJ"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_ong_com_cpf(self):
        data = {"nome": "ONG", "email": "ong2@t.com", "password": "SenhaForte123", "tipo_usuario": "ong", "cnpj": "11111111000191", "cpf": "123", "uf": "MG"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors

    def test_ong_cnpj_invalido_matematica(self):
        data = {"nome": "ONG Bad", "email": "bad@ong.com", "password": "SenhaForte123", "tipo_usuario": "ong", "cnpj": "00000000000000", "uf": "ES"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_voluntario_sem_cpf(self):
        data = {"nome": "Vol", "email": "v@t.com", "password": "SenhaForte123", "tipo_usuario": "voluntario", "uf": "BA"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors

    def test_voluntario_com_cnpj(self):
        data = {"nome": "Vol", "email": "v2@t.com", "password": "SenhaForte123", "tipo_usuario": "voluntario", "cpf": "52998224725", "cnpj": "123", "uf": "AM"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cnpj" in serializer.errors

    def test_voluntario_cpf_invalido_matematica(self):
        data = {"nome": "Vol Bad", "email": "bad@vol.com", "password": "SenhaForte123", "tipo_usuario": "voluntario", "cpf": "11111111111", "uf": "PE"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "cpf" in serializer.errors
    
    def test_senha_fraca(self):
        data = {"nome": "H", "email": "h@t.com", "password": "123", "tipo_usuario": "voluntario", "cpf": "52998224725", "uf": "GO"}
        serializer = UsuarioSerializer(data=data)
        assert not serializer.is_valid()
        assert "password" in serializer.errors


class TestValidatorsMath:
    """
    Testes Unitários da Lógica Pura (utils/validators.py).
    """
    
    def setup_method(self):
        self.faker = Faker('pt_BR')

    # --- CPF ---
    def test_cpf_none(self): assert validate_cpf(None) is False
    def test_cpf_vazio(self): assert validate_cpf("") is False
    def test_cpf_tamanho(self): assert validate_cpf("123") is False
    def test_cpf_iguais(self): assert validate_cpf("11111111111") is False
    
    def test_cpf_fail_first_digit_coverage(self):
        """
        CORREÇÃO: Este número (11111111121) força matematicamente a falha no 
        cálculo do PRIMEIRO dígito verificador, cobrindo a linha 27.
        """
        assert validate_cpf("11111111121") is False

    def test_cpf_falha_segundo_digito_dinamico(self):
        cpf_valido = self.faker.cpf().replace('.', '').replace('-', '')
        base_com_primeiro_dv = cpf_valido[:10]
        segundo_dv_original = int(cpf_valido[10])
        segundo_dv_falso = (segundo_dv_original + 1) % 10
        cpf_quase_valido = f"{base_com_primeiro_dv}{segundo_dv_falso}"
        assert validate_cpf(cpf_quase_valido) is False

    def test_cpf_success(self): 
        cpf = self.faker.cpf().replace('.', '').replace('-', '')
        assert validate_cpf(cpf) is True

    # --- CNPJ ---
    def test_cnpj_none(self): assert validate_cnpj(None) is False
    def test_cnpj_vazio(self): assert validate_cnpj("") is False
    def test_cnpj_tamanho(self): assert validate_cnpj("123") is False
    def test_cnpj_iguais(self): assert validate_cnpj("22222222222222") is False
    def test_cnpj_fail_first(self): assert validate_cnpj("11111111000101") is False
    def test_cnpj_fail_second(self): assert validate_cnpj("11111111000190") is False
    def test_cnpj_success(self): assert validate_cnpj("11111111000191") is True

    # --- SENHA ---
    def test_pass_none(self): assert validate_strong_password(None) is False
    def test_pass_short(self): assert validate_strong_password("Ab1") is False
    def test_pass_no_letter(self): assert validate_strong_password("12345678") is False
    def test_pass_no_number(self): assert validate_strong_password("ABCDEFGH") is False
    def test_pass_success(self): assert validate_strong_password("SenhaForte1") is True

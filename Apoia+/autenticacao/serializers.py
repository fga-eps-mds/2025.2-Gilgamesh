from rest_framework import serializers
from .models import Usuario
# Importando os validadores
from utils.validators import validate_cpf, validate_cnpj, validate_strong_password

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'nome', 'email', 'password', 'tipo_usuario', 'cpf', 'cnpj', 'endereco', 'descricao']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        return Usuario.objects.create_user(**validated_data)

    def validate(self, data):
        tipo = data.get('tipo_usuario')
        cpf = data.get('cpf')
        cnpj = data.get('cnpj')
        password = data.get('password')

        # --- VALIDAÇÃO DE SENHA FORTE ---
        # Só valida se a senha foi enviada (importante para updates parciais futuramente)
        if password and not validate_strong_password(password):
            raise serializers.ValidationError(
                {"password": "A senha deve ter no mínimo 8 caracteres, contendo letras e números."}
            )

        # --- REGRAS DE NEGÓCIO E VALIDAÇÃO DE DOCUMENTOS ---
        
        if tipo == 'ong':
            if not cnpj:
                raise serializers.ValidationError({"cnpj": "ONGs precisam informar o CNPJ."})
            if cpf:
                 raise serializers.ValidationError({"cpf": "ONGs não devem ter CPF."})
            
            # Validação Matemática do CNPJ
            if not validate_cnpj(cnpj):
                raise serializers.ValidationError({"cnpj": "CNPJ inválido."})

        elif tipo == 'voluntario':
            if not cpf:
                raise serializers.ValidationError({"cpf": "Voluntários precisam informar o CPF."})
            if cnpj:
                 raise serializers.ValidationError({"cnpj": "Voluntários não devem ter CNPJ."})
            
            # Validação Matemática do CPF
            if not validate_cpf(cpf):
                raise serializers.ValidationError({"cpf": "CPF inválido."})
        
        return data

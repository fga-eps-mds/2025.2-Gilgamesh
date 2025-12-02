#Este arquivo transformar o JSON que vem do flutter em objetos Python para o Django

from rest_framework import serializers
from .models import Usuario

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'nome', 'email', 'password', 'tipo_usuario', 'cpf', 'cnpj', 'endereco', 'descricao']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # Usa o create_user do Manager para garantir a criptografia da senha
        return Usuario.objects.create_user(**validated_data)

    def validate(self, data):
        tipo = data.get('tipo_usuario')
        
        # Regra 1: Se for ONG, CNPJ é obrigatório
        if tipo == 'ong':
            if not data.get('cnpj'):
                raise serializers.ValidationError({"cnpj": "ONGs precisam informar o CNPJ."})
            if data.get('cpf'):
                 raise serializers.ValidationError({"cpf": "ONGs não devem ter CPF."})

        # Regra 2: Se for Voluntário, CPF é obrigatório
        elif tipo == 'voluntario':
            if not data.get('cpf'):
                raise serializers.ValidationError({"cpf": "Voluntários precisam informar o CPF."})
            if data.get('cnpj'):
                 raise serializers.ValidationError({"cnpj": "Voluntários não devem ter CNPJ."})
        
        return data
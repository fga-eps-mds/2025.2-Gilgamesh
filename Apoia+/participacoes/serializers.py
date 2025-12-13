from rest_framework import serializers
from .models import Participacao
from autenticacao.serializers import UsuarioSerializer

class ParticipacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participacao
        fields = ['id', 'voluntario', 'evento', 'data_inscricao']
        read_only_fields = ['voluntario']

class ParticipacaoDetalhadaSerializer(serializers.ModelSerializer):

    voluntario = UsuarioSerializer(read_only=True)
    
    class Meta:
        model = Participacao
        fields = ['id', 'voluntario', 'evento', 'data_inscricao']
        read_only_fields = ['voluntario', 'evento', 'data_inscricao']

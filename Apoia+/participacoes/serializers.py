from rest_framework import serializers
from .models import Participacao

class ParticipacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participacao
        fields = ['id', 'voluntario', 'evento', 'data_inscricao']
        read_only_fields = ['voluntario'] # O voluntário será pego do token
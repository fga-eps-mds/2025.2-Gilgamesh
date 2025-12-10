from rest_framework import serializers
from .models import Evento

class EventoSerializer(serializers.ModelSerializer):
    criado_por = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Evento
        fields = [
            'id',
            'titulo',
            'descricao',
            'data_inicio',
            'data_fim',
            'local',
            'criado_por',
            'criado_em',
            'atualizado_em',
            'vagas',
        ]
        read_only_fields = ['criado_por', 'criado_em', 'atualizado_em']
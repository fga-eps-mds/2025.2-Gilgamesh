from rest_framework import serializers
from .models import Participacao

class ParticipacaoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participacao
        fields = '__all__'
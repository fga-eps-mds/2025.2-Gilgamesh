from rest_framework import viewsets
from .models import Participacao
from .serializers import ParticipacaoSerializer

class ParticipacaoViewSet(viewsets.ModelViewSet):
    queryset = Participacao.objects.all()
    serializer_class = ParticipacaoSerializer
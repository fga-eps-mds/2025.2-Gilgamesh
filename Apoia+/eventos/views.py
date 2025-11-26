from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Evento
from .serializers import EventoSerializer
from autenticacao.permissions import IsONG  

class EventoViewSet(ModelViewSet):
    queryset = Evento.objects.all().order_by('-data_inicio')
    serializer_class = EventoSerializer
    permission_classes = [IsAuthenticatedOrReadOnly, IsONG]

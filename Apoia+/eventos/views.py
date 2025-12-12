from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAuthenticatedOrReadOnly, IsAuthenticated
from .models import Evento
from .serializers import EventoSerializer
from autenticacao.permissions import IsONG 

class EventoViewSet(ModelViewSet):
    #Define o que será buscado no banco
    queryset = Evento.objects.all().order_by('-data_inicio')
    
    # Define como transformar em JSON
    serializer_class = EventoSerializer
    
    # segurança
    # Lê-se: "Todo mundo pode ler (ReadOnly), mas para mexer tem que ser Autenticado E ser ONG"
    permission_classes = [IsAuthenticatedOrReadOnly, IsONG]

    #necessário para filtros de cidade/estado serem reconhecidos e funcionarem
    def get_queryset(self):
        queryset = super().get_queryset()

        cidade = self.request.query_params.get('cidade')
        estado = self.request.query_params.get('estado')

        if cidade:
            queryset = queryset.filter(local__icontains=cidade)

        if estado:
            queryset = queryset.filter(local__icontains=estado)
        return queryset

    # função para saber quem é o usuário logado
    def perform_create(self, serializer):
        serializer.save(criado_por=self.request.user)
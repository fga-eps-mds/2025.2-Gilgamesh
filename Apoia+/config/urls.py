from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from eventos.views import EventoViewSet
from participacoes.views import ParticipacaoViewSet

# Roteador Central
router = DefaultRouter()


router.register(r'eventos', EventoViewSet, basename='evento')
router.register(r'participacoes', ParticipacaoViewSet, basename='participacao')

urlpatterns = [
    path('admin/', admin.site.urls),
    
    
    path('api/auth/', include('autenticacao.urls')),
   
    path('api/', include(router.urls)),
]
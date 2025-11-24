from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ParticipacaoViewSet

router = DefaultRouter()
router.register(r'participacoes', ParticipacaoViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
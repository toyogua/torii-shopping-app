import 'package:torii_shopping/src/banners/domain/entities/banner_group.dart';
import 'package:torii_shopping/src/banners/domain/repositories/banner_repository.dart';

class GetBannersUseCase {
  BannerRepository _bannerRepository;

  GetBannersUseCase(this._bannerRepository);

  Future<List<BannerGroup>> execute(){
    return _bannerRepository.getBanners();
  }
}
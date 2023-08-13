import 'package:get_it/get_it.dart';
import 'package:tiko/data/data_source/archive_data_source.dart';
import 'package:tiko/data/data_source/data_source.dart';
import 'package:tiko/data/repo/arvhive_repo.dart';
import 'package:tiko/data/repo/data_repo.dart';

import 'common/http_service.dart';

final locator = GetIt.instance;

Future<void> setup() async {
  // final prefs = await SharedPreferences.getInstance();

  locator.registerSingleton<IHttpservice>(HttpService());
  // locator.registerSingleton<SharedPreferences>(prefs);

  locator.registerSingleton<IDataSource>(DataSourceImple(locator()));
  locator.registerSingleton<IDataRepository>(DataRepositoryImple(locator()));
  locator.registerSingleton<IArchiveDataSource>(ArchiveLocalDataSourceImple());
  locator
      .registerSingleton<IArchiveRepository>(ArchiveRepositoryImple(locator()));

  // locator.registerSingleton<IProductRepository>(
  //     ProductRepositoryImple(locator.get()));
}

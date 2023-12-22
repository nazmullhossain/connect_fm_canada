import 'package:connectfm/app/data/models/user_model.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:waveui/waveui.dart';

class UserDetailsPage extends StatelessWidget {
  final UserModel user;

  UserDetailsPage({Key? key, required this.user}) : super(key: key);

  final _controller = _Controller();
  final AppController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WaveScaffold(
        isLoading: _controller.isBusy.value,
        appBar: WaveAppBar(
          title: Text('User Details'),
        ),
        body: ListView(
          children: <Widget>[
            if (user.firstName != null)
              ListTile(
                tileColor: Get.theme.cardColor,
                title: Text('First Name'),
                subtitle: Text(user.firstName ?? ''),
              ),
            if (user.mobile != null)
              ListTile(
                tileColor: Get.theme.cardColor,
                title: Text('Mobile'),
                subtitle: Text(user.mobile ?? ''),
              ),
            if (user.email != null)
              ListTile(
                tileColor: Get.theme.cardColor,
                title: Text('Email'),
                subtitle: Text(user.email ?? ''),
              ),
            if (user.gender != null)
              ListTile(
                tileColor: Get.theme.cardColor,
                title: Text('Gender'),
                subtitle: Text(user.gender!),
              ),
            if (controller.auth.currentUser?.uid == null)
              Container(
                color: Get.theme.cardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Account'),
                                  content: Text(
                                      'Are you sure you want to delete your account? This action cannot be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () async {
                                        _controller.isBusy.value = true;
                                        Navigator.of(context).pop();
                                        await controller.deleteAccount();
                                        _controller.isBusy.value = false;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Delete your account?"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Controller extends GetxController {
  var isBusy = false.obs;
}

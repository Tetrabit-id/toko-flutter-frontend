import 'package:tetrabit_toko_pos/routes/route.dart';
import 'package:tetrabit_toko_pos/routes/state_global.dart';
import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObrolanPage extends StatefulWidget {
  const ObrolanPage({super.key});

  @override
  State<ObrolanPage> createState() => _ObrolanPageState();
}

class _ObrolanPageState extends State<ObrolanPage> {
  @override
  void initState() {
    super.initState();
    obrolan.getAPIObrolanMember();
  }

  @override
  Widget build(BuildContext context) {
    final querySize = MediaQuery.of(context);
    var listKaryawan = getApiUsersK.dataUKaryawan;

    return MediaQuery(
        data: querySize.copyWith(textScaleFactor: 0.81),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: headerObrolanPage(querySize.size, listKaryawan),
          body: const SizedBox(),
          // body: RefreshIndicator(
          //   onRefresh: () => getApiUsersK.getApi(),
          //   child: FutureBuilder(
          //       future: getApiUsersK.getApi(),
          //       initialData: getApiUsersK.dataUKaryawan,
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return const LoadingCilcular();
          //         }
          //         return Obx(
          //           () => Padding(
          //               padding: const EdgeInsets.all(15),
          //               child: obrolan.dataObrolanMember.isEmpty
          //                   ? Center(
          //                       child: Column(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           AppSvg.notFoundUserSvg,
          //                           const SizedBox(height: 25),
          //                           headerNotFound(
          //                               'Tidak ada history obrolan ditambahkan'),
          //                           const SizedBox(height: 10),
          //                         ],
          //                       ),
          //                     )
          //                   : SingleChildScrollView(
          //                       child: Column(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           const Text('Recent Message',
          //                               style: TextStyle(
          //                                   color: Colors.black,
          //                                   fontWeight: FontWeight.bold,
          //                                   fontSize: 18)),
          //                           const SizedBox(height: 5),
          //                           ListView.builder(
          //                               shrinkWrap: true,
          //                               itemCount:
          //                                   obrolan.dataObrolanMember.length,
          //                               itemBuilder: (context, index) {
          //                                 return ChatCard(
          //                                   index: index,
          //                                   obrolanMember:
          //                                       obrolan.dataObrolanMember,
          //                                 );
          //                               }),
          //                         ],
          //                       ),
          //                     )),
          //         );
          //       }),
          // ),
        ));
  }

  AppBar headerObrolanPage(Size size, List listKaryawan) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      title: const Text('Obrolan',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
      automaticallyImplyLeading: false,
      toolbarHeight: 125,
      bottom: PreferredSize(
        preferredSize: Size(size.width, 25),
        child: SizedBox(
          width: size.width,
          height: 90,
          child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
              scrollDirection: Axis.horizontal,
              itemCount: listKaryawan.length,
              itemBuilder: (context, index) {
                return ContactCard(index: index, listKaryawan: listKaryawan);
              }),
        ),
      ),
    );
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({super.key, this.index = 0, required this.listKaryawan});
  final int index;
  final List listKaryawan;

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          obrolan.karyawanId.value = widget.listKaryawan[widget.index]['_id'];
          obrolan.namaKaryawan.value =
              widget.listKaryawan[widget.index]['name'];
        });

        await obrolan.getAPIObrolanByChannel(
            'obrolan-${widget.listKaryawan[widget.index]['_id']}');

        Get.toNamed(RouteName.pesan);
      },
      child: widget.listKaryawan[widget.index]['owner'] != true
          ? Container(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryColor,
                      child: Text(
                        widget.listKaryawan[widget.index]['name']
                            .toString()
                            .substring(0, 2),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(widget.listKaryawan[widget.index]['name'].length > 6
                        ? '${widget.listKaryawan[widget.index]['name'].toString().substring(0, 5)}..📨'
                        : '${widget.listKaryawan[widget.index]['name']} 📨'),
                  ]),
            )
          : const SizedBox(),
    );
  }
}

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, this.index = 0, required this.obrolanMember});
  final int index;
  final List obrolanMember;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await obrolan
            .getAPIObrolanByChannel('${obrolanMember[index]['channel']}');
        Get.toNamed(RouteName.pesan);
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      obrolanMember[index]['member'].toString().substring(0, 2),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${obrolanMember[index]['member']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          )),
                      const SizedBox(height: 4),
                      Text(
                          obrolanMember.length > 18
                              ? '${obrolanMember[index]['lastMessage'].substring(0, 18)}..'
                              : '${obrolanMember[index]['lastMessage']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ))
                    ],
                  )
                ],
              ),
              Container(
                width: 40,
                height: 15,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text('${obrolanMember[index]['lastTime']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

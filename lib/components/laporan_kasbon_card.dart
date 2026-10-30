import 'package:tetrabit_toko_pos/style/styles.dart';
import 'package:flutter/material.dart';

class LaporanKasbonCard extends StatefulWidget {
  const LaporanKasbonCard({Key? key, this.index = 0, required this.dataKasbon})
      : super(key: key);

  final int index;
  final List dataKasbon;

  @override
  State<LaporanKasbonCard> createState() => _LaporanKasbonCardState();
}

class _LaporanKasbonCardState extends State<LaporanKasbonCard> {
  @override
  GestureDetector build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String status =
        widget.dataKasbon[widget.index]['status'][0].toString().toUpperCase() +
            widget.dataKasbon[widget.index]['status'].toString().substring(1);
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: size.width,
        height: 95,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: widget.dataKasbon[widget.index]['status'] == "sudah"
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 64, 223, 7),
                    Color.fromARGB(255, 5, 135, 29)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.orange.shade800,
                    Colors.red.shade700,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Container(
                    //   width: 40,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //       image: DecorationImage(
                    //         image: Image.asset(
                    //           'assets/img/logo_toko.png',
                    //           fit: BoxFit.cover,
                    //         ).image,
                    //       )),
                    // ),
                    // const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kasbon from',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          widget.dataKasbon[widget.index]['memberId'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ],
                ),
                Text(
                  dateFormat(widget.dataKasbon[widget.index]['date']),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Lato'),
                )
              ],
            )),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width / 2.5,
                  height: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    '${(widget.dataKasbon[widget.index]['note'])}',
                    style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontFamily: 'Lato',
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

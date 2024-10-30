import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String topLeadingText;
  final String topTitleText;
  final String topSubtitleText;
  final String bottomTitleText;
  final VoidCallback onPressed;
  const CustomListTile({super.key, required this.topLeadingText, required this.topTitleText, required this.topSubtitleText, required this.bottomTitleText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
            color: Colors.grey.withOpacity(0.4)
          )
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffF68D7F),
                  Color(0xffFCE183),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )
            ),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                  )
              ),
              /*tileColor: topBackgroundColor,*/
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text(
                    topLeadingText,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              title: Text(
                topTitleText,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              subtitle: Text(
                topSubtitleText,
                style: const TextStyle(
                  color: Colors.black
                ),
              ),
              minTileHeight: 1,
              contentPadding: const EdgeInsets.only(
                left: 10,
              ),
              trailing: IconButton(
                onPressed: onPressed,
                icon: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                )
            ),
            tileColor: Colors.white,
            title: Text(
              bottomTitleText,
              style: const TextStyle(
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}

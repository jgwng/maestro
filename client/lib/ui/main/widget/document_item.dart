import 'package:flutter/material.dart';
import 'package:client/model/documents.dart';
import 'package:client/ui/detail/screen/detail_screen.dart';

class DocumentItem extends StatelessWidget{

  const DocumentItem({super.key, required this.document,this.onTapFavoriteItem});
  final Document document;
  final VoidCallback? onTapFavoriteItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return DetailScreen(
            imageUrl: document.imageUrl ?? '',
          );
        }
        ));
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black
            ),
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  document.imageUrl ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
            ),

            Expanded(
              child: Text(
                  '출처 : ${document.displaySiteName ?? ''}',
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            InkWell(
              onTap: onTapFavoriteItem,
              child: Icon(
                  (document.isFavorite == 'TRUE') ?  Icons.favorite : Icons.favorite_outline,
                  size: 20,
                  color : Colors.deepPurple
              ),
            )
          ],
        ),
      ),
    );
  }

}
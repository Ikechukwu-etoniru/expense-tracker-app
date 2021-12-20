import 'package:flutter/material.dart';

class LineDesign extends StatelessWidget {
  const LineDesign({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CustomPaint(
      painter: MyShape(),
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
          bottom: 5
        ),
        alignment: Alignment.bottomLeft,
        child: const Text('Thrifty Expense', style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway'
        ),),
      ),
    )
      
    ;
  }
}

class MyShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    final paint = Paint();
    final path = Path();
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;
    paint.color = Colors.teal;

    path.moveTo(w * 0, h*1);
    path.lineTo(w * 0.2, h*1);
    path.lineTo(w*0.3, h*0);
    canvas.drawPath(path, paint);

    final paint2 = Paint();
    paint2.style = PaintingStyle.fill;
    paint2.color = Colors.yellow;
    path.lineTo(w*0.45, h*1);
    canvas.drawPath(path, paint2);

    final paint3 = Paint();
    final path2 = Path();
    paint3.style = PaintingStyle.fill;
    paint3.color = Colors.green;
    path2.moveTo(w*0.45, h*1);
    path2.lineTo(w*0.55, h*0);
    path2.lineTo(w*0.3, h*0);
    canvas.drawPath(path2, paint3);

    final paint4 = Paint();
    final path3 = Path();
    paint4.style = PaintingStyle.fill;
    paint4.color = Colors.lightBlue;
    path3.moveTo(w*0.45, h*1);
    path3.lineTo(w*0.7, h*1);
    path3.lineTo(w*0.55, h*0);
    path3.lineTo(w*0.45, h*1);
    canvas.drawPath(path3, paint4);

    final paint5 = Paint();
    final path4 = Path();
    paint5.style = PaintingStyle.fill;
    paint5.color = Colors.redAccent;
    path4.moveTo(w*0.7, h*1);
    path4.lineTo(w*0.85, h*0);
    path4.lineTo(w*0.55, h*0);
    path4.lineTo(w*1, h*1);
    canvas.drawPath(path4, paint5);

    final paint6 = Paint();
    final path5 = Path();
    paint6.style = PaintingStyle.fill;
    paint6.color = Colors.deepOrange;
    path5.moveTo(w*0, h*0);
    path5.lineTo(w*0, h*1);
    path5.lineTo(w*0.4, h*0);
    
    canvas.drawPath(path5, paint6);
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  
}
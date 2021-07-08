import 'package:align/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Get markdown images', () async {
    var out = getMarkdownImages(
        "blah ![My Image](me.jpg) ![My Image1](me1.jpg) blah");

    expect(out.length, 2);
    expect(out[0], "me.jpg");
    expect(out[1], "me1.jpg");
  });

  test('Replace markdown images', () async {
    var out = replaceMarkdownImages(
      "blah ![My Image](me.jpg) ![My Image1](me1.jpg) blah",
      {
        "me.jpg": "http://myserver/me.jpg",
        "me1.jpg": "http://myserver/me1.jpg"
      },
    );
    print(out);
    expect(out,
        "blah ![My Image](http://myserver/me.jpg) ![My Image1](http://myserver/me1.jpg) blah");
  });
}

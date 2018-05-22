class Issue {
  // API properties
  final int iid;
  final String date;
  final int status;
  final String topic;
  final String preface;
  final String postface;
  String cover;

  Issue.fromMap(Map<String, dynamic> map)
    : iid = map['iid'],
      date = map['date'] ?? '',
      status = map['status'] ?? 0,
      topic = map['topic'] ?? '',
      preface = map['preface'] ?? '',
      postface = map['postface'] ?? '',
      cover = IssueCovers[map['iid'] % IssueCovers.length];
}

const IssueCovers = [
  "https://p0.ssl.qhimg.com/t014c157ea173b3e7a0.png",
  "https://p0.ssl.qhimg.com/t01b8113d3c493f57be.png",
  "https://p0.ssl.qhimg.com/t01d142792038122f29.png",
  "https://p0.ssl.qhimg.com/t01e6624b5278db3a6a.png",
  "https://p0.ssl.qhimg.com/t01315b058f1f0ac00d.png",
  "https://p0.ssl.qhimg.com/t01375133e502f345de.png",
  "https://p0.ssl.qhimg.com/t01a5a2af2b31088fc4.png",
  "https://p0.ssl.qhimg.com/t015ad54a71145c35e0.png",
  "https://p0.ssl.qhimg.com/t01cef5d8f56577f47d.png",
  "https://p0.ssl.qhimg.com/t01c2c238bc4682adb7.png",
  "https://p0.ssl.qhimg.com/t019cfe4109400e8518.png",
  "https://p0.ssl.qhimg.com/t01077db307a494f1ee.png",
  "https://p0.ssl.qhimg.com/t0199717cebecb2a4c8.png",
  "https://p0.ssl.qhimg.com/t011e4e0f91294136ca.png",
  "https://p0.ssl.qhimg.com/t014e459231c2235a05.png",
  "https://p0.ssl.qhimg.com/t01388cf09768cd2861.png",
  "https://p0.ssl.qhimg.com/t01f61b909ec47f4c82.png",
  "https://p0.ssl.qhimg.com/t013bf807f05aa71f1b.png",
  "https://p0.ssl.qhimg.com/t01f2e66dd1ca9ac91b.png",
  "https://p0.ssl.qhimg.com/t01678fb5f9c905b176.png",
  "https://p0.ssl.qhimg.com/t01290b68ca1ad991c5.png",
  "https://p0.ssl.qhimg.com/t01b30b39f7f9c26449.png",
  "https://p0.ssl.qhimg.com/t01b2a4d8616cea765b.png",
  "https://p0.ssl.qhimg.com/t012d4c028f7c9c4238.png",
  "https://p0.ssl.qhimg.com/t017a406ddf9a22940d.png",
  "https://p0.ssl.qhimg.com/t017755d14a5f0a7edc.png",
  "https://p0.ssl.qhimg.com/t01c876095b33bad136.png",
  "https://p0.ssl.qhimg.com/t01af9bed820629fd9e.png",
  "https://p0.ssl.qhimg.com/t0198f09c4be200d851.png",
  "https://p0.ssl.qhimg.com/t01a82c8e9ca14e0cae.png",
  "https://p0.ssl.qhimg.com/t01a035f4e6470c150c.png",
  "https://p0.ssl.qhimg.com/t014050c360ff5b1fd7.png",
  "https://p0.ssl.qhimg.com/t01c302551eb8c99306.png"
];

Return-Path: <ngompa13@gmail.com>
Return-Path: <ngompa13@gmail.com>
MIME-Version: 1.0
From: Neal Gompa <ngompa@fedoraproject.org>
Date: Fri, 21 Aug 2015 15:17:58 -0400
Message-ID: <CAEg-Je_AczM9EyocTwE9dQN-0Q=OgSqkkcqJKqR+E-5kjXY66Q@mail.gmail.com>
Subject: Issue: With an OverlayFS that has Btrfs as the upper layer, removal
 of directories silently fails
Content-Type: multipart/alternative; boundary=047d7bd6be0e80caf7051dd7225a
To: miklos@szeredi.hu, Chris Mason <clm@fb.com>, jbacik@fb.com, dsterba@suse.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: jwboyer@redhat.com, dhowells@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

--047d7bd6be0e80caf7051dd7225a
Content-Type: text/plain; charset=UTF-8

Hello,

Yesterday I filed an issue in the CentOS bug tracker (#9297
<https://bugs.centos.org/view.php?id=9297>) and the Red Hat Bugzilla (
#1255512 <https://bugzilla.redhat.com/show_bug.cgi?id=1255512>) about
OverlayFS with Btrfs as the upper layer.

The issue was discovered by a colleague of mine, and we verified the issue
exists in the EL7 kernel and mainline kernels (tested on Arch Linux). I
additionally verified the problem exists in Fedora kernels.

Rather than quoting the issue, I'll just note that the issue is described
quite well in the filed bugs linked earlier. In the linked bugs, there's a
simple Bash script that will reliably reproduce the problem. While the
script uses tmpfs at the lower layer, we originally discovered the problem
with ext4 as the lower layer and verified that it doesn't matter which
lower layer filesystem it is, the problem exists. Additionally, the problem
doesn't exist when using ext4 as the upper layer.

I was advised by Josh Boyer to email you guys (and the mailing lists, to be
sure to get everyone a chance to look over it) about the problem, since it
affects mainline.


-- 
Neal Gompa (FAS: ngompa)

--047d7bd6be0e80caf7051dd7225a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:times ne=
w roman,serif;font-size:large"><div class=3D"gmail_default">Hello,</div><di=
v class=3D"gmail_default"><br></div><div class=3D"gmail_default">Yesterday =
I filed an issue in the CentOS bug tracker (<a href=3D"https://bugs.centos.=
org/view.php?id=3D9297" target=3D"_blank">#9297</a>) and the Red Hat Bugzil=
la (<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D1255512" targe=
t=3D"_blank">#1255512</a>) about OverlayFS with Btrfs as the upper layer.</=
div><div class=3D"gmail_default"><br></div><div class=3D"gmail_default">The=
 issue was discovered by a colleague of mine, and we verified the issue exi=
sts in the EL7 kernel and mainline kernels (tested on Arch Linux). I additi=
onally verified the problem exists in Fedora kernels.</div><div class=3D"gm=
ail_default"><br></div><div class=3D"gmail_default">Rather than quoting the=
 issue, I&#39;ll just note that the issue is described quite well in the fi=
led bugs linked earlier. In the linked bugs, there&#39;s a simple Bash scri=
pt that will reliably reproduce the problem. While the script uses tmpfs at=
 the lower layer, we originally discovered the problem with ext4 as the low=
er layer and verified that it doesn&#39;t matter which lower layer filesyst=
em it is, the problem exists. Additionally, the problem doesn&#39;t exist w=
hen using ext4 as the upper layer.</div><div class=3D"gmail_default"><br></=
div><div class=3D"gmail_default">I was advised by Josh Boyer to email you g=
uys (and the mailing lists, to be sure to get everyone a chance to look ove=
r it) about the problem, since it affects mainline.</div></div><br clear=3D=
"all"><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"=
>Neal Gompa (FAS: ngompa)</div></div>
<font face=3D"yw-402608bc37fe50adb11a5899295781aeb83d248d-7a96b0ca75bbb41c4=
791a285050ebb03--o" style=3D"display: none;"></font></div>

--047d7bd6be0e80caf7051dd7225a--

Return-Path: <steve.landiss@yahoo.com>
Date: Fri, 22 May 2015 00:51:03 +0000 (UTC)
From: steve landiss <steve.landiss@yahoo.com>
Reply-To: steve landiss <steve.landiss@yahoo.com>
Message-ID: <423094758.67304.1432255863385.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <CAJfpegsGtzK-ykK7tXJjZabAZERJ_NcMyZbeTkB5HB3s-43Skg@mail.gmail.com>
References: <CAJfpegsGtzK-ykK7tXJjZabAZERJ_NcMyZbeTkB5HB3s-43Skg@mail.gmail.com>
Subject: Re: Bug in overlay FS
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_67303_2052761729.1432255863381"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-unionfs@vger.kernel.org>

------=_Part_67303_2052761729.1432255863381
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

A company we are evaluating says they =C2=A0have a fix for this and they ad=
vised me that they will send you the fix shortly.
Regards,Steve=20


     On Thursday, May 21, 2015 8:38 AM, Miklos Szeredi <miklos@szeredi.hu> =
wrote:
  =20

 [Al Viro and linux-unionfs added to Cc]

On Tue, May 19, 2015 at 11:30 PM, steve landiss <steve.landiss@yahoo.com> w=
rote:
>
> On Tuesday, May 19, 2015 2:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrot=
e:
> >
> >
> > On Mon, May 18, 2015 at 10:35 PM, steve landiss <steve.landiss@yahoo.co=
m>
> > wrote:
> >
> >> A data consistency bug is demonstrated by the following program:
> >>
> >> - Pick a file from the lower layer that has never been written
> >> - Open it twice once in O_RDONLY (fd1) and once in O_RDWR (fd2)
> >> - Write to fd2, read from fd1 -> data inconsistency!
> >> I understand why it happens, is there a fix planned for this?
> >
> >
>>=C2=A0 Not presently.
> >
> > This is a feature of both overlayfs and union-mounts.=C2=A0 Aufs, a ful=
l
> > union-filesystem doesn't suffer from this probelm.
> >
> > Is this causing a real-world problem, or is this purely theoretical?

> yum fails right off the bat.=C2=A0 Because it opens a file in read only, =
then
> another process or thread writes to the file.
>
> Our build process in Docker does not work because of this, and I know of
> many others that have this issue
>
> overlayfs fails to run container with a strange file checksum error =C2=
=B7 Issue
> #10180 =C2=B7 docker/docker

Okay, this is not easy to fix, but I wouldn't say impossible.

I think it connects with the idea of revoking file descriptors.
Except here we don't want to revoke, but replace on copy-up.

But it might be easier to just to do the union-filesystem thing.

Thanks,
Miklos

  
------=_Part_67303_2052761729.1432255863381
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif;fo=
nt-size:16px"><div id=3D"yui_3_16_0_1_1432255719543_3595"><span id=3D"yui_3=
_16_0_1_1432255719543_3617">A company we are evaluating says they &nbsp;hav=
e a fix for this and they advised me that they will send you the fix shortl=
y.</span></div><div id=3D"yui_3_16_0_1_1432255719543_3595"><span><br></span=
></div><div id=3D"yui_3_16_0_1_1432255719543_3595">Regards,</div><div id=3D=
"yui_3_16_0_1_1432255719543_3595"><span>Steve</span></div>  <br><div class=
=3D"qtdSeparateBR"><br><br></div><div class=3D"yahoo_quoted" style=3D"displ=
ay: block;"> <div style=3D"font-family: HelveticaNeue, Helvetica Neue, Helv=
etica, Arial, Lucida Grande, sans-serif; font-size: 16px;"> <div style=3D"f=
ont-family: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande,=
 sans-serif; font-size: 16px;"> <div dir=3D"ltr"> <font size=3D"2" face=3D"=
Arial"> On Thursday, May 21, 2015 8:38 AM, Miklos Szeredi &lt;miklos@szered=
i.hu&gt; wrote:<br> </font> </div>  <br><br> <div class=3D"y_msg_container"=
>[Al Viro and linux-unionfs added to Cc]<br clear=3D"none"><br clear=3D"non=
e">On Tue, May 19, 2015 at 11:30 PM, steve landiss &lt;<a shape=3D"rect" ym=
ailto=3D"mailto:steve.landiss@yahoo.com" href=3D"mailto:steve.landiss@yahoo=
.com">steve.landiss@yahoo.com</a>&gt; wrote:<br clear=3D"none">&gt;<br clea=
r=3D"none">&gt; On Tuesday, May 19, 2015 2:12 AM, Miklos Szeredi &lt;<a sha=
pe=3D"rect" ymailto=3D"mailto:miklos@szeredi.hu" href=3D"mailto:miklos@szer=
edi.hu">miklos@szeredi.hu</a>&gt; wrote:<br clear=3D"none">&gt; &gt;<br cle=
ar=3D"none">&gt; &gt;<br clear=3D"none">&gt; &gt; On Mon, May 18, 2015 at 1=
0:35 PM, steve landiss &lt;<a shape=3D"rect" ymailto=3D"mailto:steve.landis=
s@yahoo.com" href=3D"mailto:steve.landiss@yahoo.com">steve.landiss@yahoo.co=
m</a>&gt;<br clear=3D"none">&gt; &gt; wrote:<br clear=3D"none">&gt; &gt;<br=
 clear=3D"none">&gt; &gt;&gt; A data consistency bug is demonstrated by the=
 following program:<br clear=3D"none">&gt; &gt;&gt;<br clear=3D"none">&gt; =
&gt;&gt; - Pick a file from the lower layer that has never been written<br =
clear=3D"none">&gt; &gt;&gt; - Open it twice once in O_RDONLY (fd1) and onc=
e in O_RDWR (fd2)<br clear=3D"none">&gt; &gt;&gt; - Write to fd2, read from=
 fd1 -&gt; data inconsistency!<br clear=3D"none">&gt; &gt;&gt; I understand=
 why it happens, is there a fix planned for this?<br clear=3D"none">&gt; &g=
t;<br clear=3D"none">&gt; &gt;<br clear=3D"none">&gt;&gt;&nbsp; Not present=
ly.<br clear=3D"none">&gt; &gt;<br clear=3D"none">&gt; &gt; This is a featu=
re of both overlayfs and union-mounts.&nbsp; Aufs, a full<br clear=3D"none"=
>&gt; &gt; union-filesystem doesn't suffer from this probelm.<br clear=3D"n=
one">&gt; &gt;<br clear=3D"none">&gt; &gt; Is this causing a real-world pro=
blem, or is this purely theoretical?<br clear=3D"none"><br clear=3D"none">&=
gt; yum fails right off the bat.&nbsp; Because it opens a file in read only=
, then<br clear=3D"none">&gt; another process or thread writes to the file.=
<br clear=3D"none">&gt;<br clear=3D"none">&gt; Our build process in Docker =
does not work because of this, and I know of<br clear=3D"none">&gt; many ot=
hers that have this issue<br clear=3D"none">&gt;<br clear=3D"none">&gt; ove=
rlayfs fails to run container with a strange file checksum error =C2=B7 Iss=
ue<br clear=3D"none">&gt; #10180 =C2=B7 docker/docker<br clear=3D"none"><br=
 clear=3D"none">Okay, this is not easy to fix, but I wouldn't say impossibl=
e.<br clear=3D"none"><br clear=3D"none">I think it connects with the idea o=
f revoking file descriptors.<br clear=3D"none">Except here we don't want to=
 revoke, but replace on copy-up.<br clear=3D"none"><br clear=3D"none">But i=
t might be easier to just to do the union-filesystem thing.<div class=3D"yq=
t7093223255" id=3D"yqtfd29178"><br clear=3D"none"><br clear=3D"none">Thanks=
,<br clear=3D"none">Miklos</div><br><br></div>  </div> </div>  </div></div>=
</body></html>
------=_Part_67303_2052761729.1432255863381--

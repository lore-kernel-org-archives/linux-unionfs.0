Return-Path: <saied@google.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
References: <20150415085013.GA8907@odin.com>
	<CAJfpegvKvuu7mtxz+nV1qxpEddf2ZMroBaz+rkFTFVQZ2PoQRw@mail.gmail.com>
Date: Wed, 15 Apr 2015 10:47:59 -0700
Message-ID: <CA+Um-ggZRdmxS4+YJ0FNygrQvZgjgOiDswyr+HbfAFnO9rJHnA@mail.gmail.com>
Subject: Re: procfs reports unexpected mnt_id and path for overlayfs files
From: Saied Kazemi <saied@google.com>
Content-Type: multipart/alternative; boundary=047d7b33d4f2b02eb10513c6f21a
To: Miklos Szeredi <miklos@szeredi.hu>, Andrew Vagin <avagin@odin.com>
Cc: CRIU <criu@openvz.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--047d7b33d4f2b02eb10513c6f21a
Content-Type: text/plain; charset=UTF-8

Andrew, thank you for reporting and providing an easy way to reproduce the
problem.

Miklos, thanks for the quick reply.  If you'd like to see the issue with
checkpointing and restoring Docker containers using OverlayFS, you can use
the docker binary here  https://github.com/SaiedKazemi/docker/releases.

--Saied




On Wed, Apr 15, 2015 at 8:07 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Wed, Apr 15, 2015 at 10:50 AM, Andrew Vagin <avagin@odin.com> wrote:
> > Hello Miklos and Everyone else,
> >
> > We have a report that a container with overlayfs can't be checkpointed.
> >
> > To dump file descriptors we get information from /proc/pid/fd/ and
> /proc/pid/fdinfo.
> >
> > But in case of overlayfs we see unexpected values there.
> >
> > /proc/PID/fdinfo/FD contains mnt_id which isn't presented in
> /proc/pid/mountinfo.
> > /proc/PID/fd/FD does not contain an absolute path to the opened file.
> >
> > Can someone help to fix these issues?
>
> See this:
>
> https://lkml.org/lkml/2015/3/20/372
>
> Al didn't like that patch.  But it definitely will be fixed, one way
> or the other, in the near future.
>
> Thanks,
> Miklos
>

--047d7b33d4f2b02eb10513c6f21a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Andrew, thank you for reporting and providing an easy way =
to reproduce the problem.<div><br></div><div>Miklos, thanks for the quick r=
eply.=C2=A0 If you&#39;d like to see the issue with checkpointing and resto=
ring Docker containers using OverlayFS, you can use the docker binary here =
=C2=A0<a href=3D"https://github.com/SaiedKazemi/docker/releases">https://gi=
thub.com/SaiedKazemi/docker/releases</a>.</div><div><br></div><div>--Saied<=
/div><div><br><div><br></div><div><br></div></div></div><div class=3D"gmail=
_extra"><br><div class=3D"gmail_quote">On Wed, Apr 15, 2015 at 8:07 AM, Mik=
los Szeredi <span dir=3D"ltr">&lt;<a href=3D"mailto:miklos@szeredi.hu" targ=
et=3D"_blank">miklos@szeredi.hu</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Wed, Apr 15, 2015 at 10:50 AM, Andrew Vag=
in &lt;<a href=3D"mailto:avagin@odin.com">avagin@odin.com</a>&gt; wrote:<br=
>
&gt; Hello Miklos and Everyone else,<br>
&gt;<br>
&gt; We have a report that a container with overlayfs can&#39;t be checkpoi=
nted.<br>
&gt;<br>
&gt; To dump file descriptors we get information from /proc/pid/fd/ and /pr=
oc/pid/fdinfo.<br>
&gt;<br>
&gt; But in case of overlayfs we see unexpected values there.<br>
&gt;<br>
&gt; /proc/PID/fdinfo/FD contains mnt_id which isn&#39;t presented in /proc=
/pid/mountinfo.<br>
&gt; /proc/PID/fd/FD does not contain an absolute path to the opened file.<=
br>
&gt;<br>
&gt; Can someone help to fix these issues?<br>
<br>
</span>See this:<br>
<br>
<a href=3D"https://lkml.org/lkml/2015/3/20/372" target=3D"_blank">https://l=
kml.org/lkml/2015/3/20/372</a><br>
<br>
Al didn&#39;t like that patch.=C2=A0 But it definitely will be fixed, one w=
ay<br>
or the other, in the near future.<br>
<br>
Thanks,<br>
Miklos<br>
</blockquote></div><br></div>

--047d7b33d4f2b02eb10513c6f21a--

Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
References: <CALLuPvpczs-UiDkoHURAu7weCHJCv9U6xKxDKck=5U85T55ukw@mail.gmail.com>
 <1521025377.4552.6.camel@kernel.org> <1521037013.40526.8.camel@primarydata.com>
 <1521037854.4552.19.camel@kernel.org> <CAOQ4uxig8aM2WnVQniAXWBOWtnv8ciqqBWXZZgG-foVW04bofQ@mail.gmail.com>
 <1521039981.40526.11.camel@primarydata.com> <CAOQ4uxj5GqmMCLpeq0oHacUPeSRu6P7GyiQP=13YBq9C7GgBGQ@mail.gmail.com>
 <CALLuPvpSXg57BORs70fvvANOFKfqeXO5uuorHESj24N8KWEOTQ@mail.gmail.com>
In-Reply-To: <CALLuPvpSXg57BORs70fvvANOFKfqeXO5uuorHESj24N8KWEOTQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Thu, 15 Mar 2018 09:23:39 +0000
Message-ID: <CALLuPvqOk4=SaogrwMTJHvx6b7PuPmvS22Jc3=g+6h14sBukVg@mail.gmail.com>
Subject: Re: readdir returns d_type=DT_UNKNOWN to overlay exported dir (NFSv3)
Content-Type: multipart/alternative; boundary="94eb2c03cef4b56eff0567700c98"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@kernel.org>, "bfields@fieldses.org" <bfields@fieldses.org>, "miklos@szeredi.hu" <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

--94eb2c03cef4b56eff0567700c98
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Eddie Horng <eddiehorng.tw@gmail.com> =E6=96=BC 2018=E5=B9=B43=E6=9C=8814=
=E6=97=A5=E9=80=B1=E4=B8=89 23:40 =E5=AF=AB=E9=81=93=EF=BC=9A

> This is an always reproduced case for NFSv3 over overlayfs, and each
> dir under nfs mount point behaviors the same. The same overlay
> exported mount with NFSv4 returns correct d_type. And for ext4
> exported mount with NFSv3 returns correct as well.
>
> My simple test program is like:
> void main(int argc, void **argv) {
>     DIR *dir =3D opendir(argv[1]);
>
>     if (dir =3D=3D NULL) {
>         fprintf(stderr,
>                 "ERROR: Could not open dir: %s\n", argv[1]);
>         return;
>     }
>     struct dirent *ent;
>     while ((ent =3D readdir(dir)) !=3D NULL) {
>        printf("readdir: %s ino(%x) type(%x)\n", ent->d_name,
> ent->d_ino, ent->d_type);
>     }
>     closedir(dir);
>
> }
>
> output is:
> readdir: . ino(e0003) type(0)
> readdir: .. ino(e0003) type(0)
> readdir: foo ino(e0007) type(0)
>
> 2018-03-14 23:14 GMT+08:00 Amir Goldstein <amir73il@gmail.com>:
> > On Wed, Mar 14, 2018 at 5:06 PM, Trond Myklebust
> > <trondmy@primarydata.com> wrote:
> >> On Wed, 2018-03-14 at 17:03 +0200, Amir Goldstein wrote:
> >>> On Wed, Mar 14, 2018 at 4:30 PM, Jeff Layton <jlayton@kernel.org>
> >>> wrote:
> >>> > On Wed, 2018-03-14 at 14:16 +0000, Trond Myklebust wrote:
> >>> > > On Wed, 2018-03-14 at 07:02 -0400, Jeff Layton wrote:
> >>> > > > On Wed, 2018-03-14 at 16:42 +0800, Eddie Horng wrote:
> >>> > > > > Hi Amir,
> >>> > > > > Since the flock issue is clarified, I would like to start
> >>> > > > > this new
> >>> > > > > thread to discuss if we can find the cause of
> >>> > > > > d_type=3DDT_UNKNOWN.
> >>> > > > > First
> >>> > > >
> >>> > > > This sounds like NOTABUG to me. As readdir(3) states:
> >>> > > >
> >>> > > > Currently, only some filesystems (among them: Btrfs, ext2,
> >>> > > > ext3,
> >>> > > > and ext4) have full
> >>> > > > support  for  returning  the  file  type  in
> >>> > > > d_type.   All  applications  must  properly  handle  a return
> >>> > > > of
> >>> > > > DT_UNKNOWN.
> >>> > > >
> >>> > > > Applications that rely solely on d_type are effectively broken.
> >>> > > > You
> >>> > > > always need to be able to follow up with a stat or equivalent.
> >>> > > >
> >>> > >
> >>> > > Yes, but one of the main such applications is the "find" utility,
> >>> > > which
> >>> > > uses it to avoid calling stat() in order to discover the
> >>> > > directories.
> >>> > > For that reason, NFS does try to set the d_type flag when it is
> >>> > > using
> >>> > > readdirplus, and the server returns attributes for the entry in
> >>> > > question. Otherwise, it is forced to default to DT_UNKNOWN.
> >>> > >
> >>> >
> >>> > Yes, didn't mean to imply that we shouldn't try to fill these out
> >>> > where
> >>> > we can, just that there are situations where we might not be able
> >>> > to do
> >>> > so without taking a performance hit.
> >>> >
> >>> > > Note that in the cases where the readdir entry has a matching
> >>> > > dentry,
> >>> > > we probably could try to do better by doing a d_lookup() and then
> >>> > > filling the d_type. Is that worth doing?
> >>> > >
> >>> >
> >>> > I like that idea. Filling out what info we can from the local cache
> >>> > is
> >>> > almost always worthwhile.
> >>> >
> >>> > An inode's d_type can never change, so you can just vet the fileid
> >>> > or fh
> >>> > in the entry3 vs. the inode that comes back from d_lookup. If they
> >>> > match
> >>> > then you can reliably fill that out.
> >>> >
> >>>
> >>> Ironically, this is where NFS over overlayfs may fail, because in
> >>> overlayfs
> >>> d_ino is not always consistent with st_ino. Since v4.15, d_ino is
> >>> consistent
> >>> with st_ino for the case of all layers on the same filesystem. I
> >>> already posted
> >>> a POC for fixing d_ino/st_ino for non-samefs, but it never got
> >>> merged.
> >>>
> >>> What puzzles me w.r.t. this "nonbug" report is that I don't
> >>> understand why
> >>> NFS over overlayfs would behave differently vs. NFS over local fs.
> >>> I am hoping it does not point to a different problem, so would love
> >>> to
> >>> get a more detailed analysis of what's going on between nfsd and
> >>> overlayfs.
> >>
> >> The behaviour being described is true of the regular NFS client. It ha=
s
> >> nothing to do with overlayfs.
> >>
> >
> > Here:
> > https://marc.info/?l=3Dlinux-unionfs&m=3D152093050204357&w=3D2
> >
> > Eddie claims that the observed DT_UNKNOWN issue is reproduced
> > with NFSv3 over overlayfs and NOT with NFSv3 over ext4.
> >
> > That's the only fact I find puzzling.
> >
> > But I did not see a confirmation that this is a reproducible problem
> > with exact same directory and I did not try to reproduce it myself.
> >
> > Thanks,
> > Amir.
>

--94eb2c03cef4b56eff0567700c98
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">Edd=
ie Horng &lt;<a href=3D"mailto:eddiehorng.tw@gmail.com">eddiehorng.tw@gmail=
.com</a>&gt; =E6=96=BC 2018=E5=B9=B43=E6=9C=8814=E6=97=A5=E9=80=B1=E4=B8=89=
 23:40 =E5=AF=AB=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
This is an always reproduced case for NFSv3 over overlayfs, and each<br>
dir under nfs mount point behaviors the same. The same overlay<br>
exported mount with NFSv4 returns correct d_type. And for ext4<br>
exported mount with NFSv3 returns correct as well.<br>
<br>
My simple test program is like:<br>
void main(int argc, void **argv) {<br>
=C2=A0 =C2=A0 DIR *dir =3D opendir(argv[1]);<br>
<br>
=C2=A0 =C2=A0 if (dir =3D=3D NULL) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;ERROR: Could =
not open dir: %s\n&quot;, argv[1]);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
=C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 struct dirent *ent;<br>
=C2=A0 =C2=A0 while ((ent =3D readdir(dir)) !=3D NULL) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0printf(&quot;readdir: %s ino(%x) type(%x)\n&quot=
;, ent-&gt;d_name,<br>
ent-&gt;d_ino, ent-&gt;d_type);<br>
=C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 closedir(dir);<br>
<br>
}<br>
<br>
output is:<br>
readdir: . ino(e0003) type(0)<br>
readdir: .. ino(e0003) type(0)<br>
readdir: foo ino(e0007) type(0)<br>
<br>
2018-03-14 23:14 GMT+08:00 Amir Goldstein &lt;<a href=3D"mailto:amir73il@gm=
ail.com" target=3D"_blank" rel=3D"noreferrer">amir73il@gmail.com</a>&gt;:<b=
r>
&gt; On Wed, Mar 14, 2018 at 5:06 PM, Trond Myklebust<br>
&gt; &lt;<a href=3D"mailto:trondmy@primarydata.com" target=3D"_blank" rel=
=3D"noreferrer">trondmy@primarydata.com</a>&gt; wrote:<br>
&gt;&gt; On Wed, 2018-03-14 at 17:03 +0200, Amir Goldstein wrote:<br>
&gt;&gt;&gt; On Wed, Mar 14, 2018 at 4:30 PM, Jeff Layton &lt;<a href=3D"ma=
ilto:jlayton@kernel.org" target=3D"_blank" rel=3D"noreferrer">jlayton@kerne=
l.org</a>&gt;<br>
&gt;&gt;&gt; wrote:<br>
&gt;&gt;&gt; &gt; On Wed, 2018-03-14 at 14:16 +0000, Trond Myklebust wrote:=
<br>
&gt;&gt;&gt; &gt; &gt; On Wed, 2018-03-14 at 07:02 -0400, Jeff Layton wrote=
:<br>
&gt;&gt;&gt; &gt; &gt; &gt; On Wed, 2018-03-14 at 16:42 +0800, Eddie Horng =
wrote:<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; Hi Amir,<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; Since the flock issue is clarified, I woul=
d like to start<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; this new<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; thread to discuss if we can find the cause=
 of<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; d_type=3DDT_UNKNOWN.<br>
&gt;&gt;&gt; &gt; &gt; &gt; &gt; First<br>
&gt;&gt;&gt; &gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt; &gt; This sounds like NOTABUG to me. As readdir(3) s=
tates:<br>
&gt;&gt;&gt; &gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt; &gt; Currently, only some filesystems (among them: B=
trfs, ext2,<br>
&gt;&gt;&gt; &gt; &gt; &gt; ext3,<br>
&gt;&gt;&gt; &gt; &gt; &gt; and ext4) have full<br>
&gt;&gt;&gt; &gt; &gt; &gt; support=C2=A0 for=C2=A0 returning=C2=A0 the=C2=
=A0 file=C2=A0 type=C2=A0 in<br>
&gt;&gt;&gt; &gt; &gt; &gt; d_type.=C2=A0 =C2=A0All=C2=A0 applications=C2=
=A0 must=C2=A0 properly=C2=A0 handle=C2=A0 a return<br>
&gt;&gt;&gt; &gt; &gt; &gt; of<br>
&gt;&gt;&gt; &gt; &gt; &gt; DT_UNKNOWN.<br>
&gt;&gt;&gt; &gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt; &gt; Applications that rely solely on d_type are eff=
ectively broken.<br>
&gt;&gt;&gt; &gt; &gt; &gt; You<br>
&gt;&gt;&gt; &gt; &gt; &gt; always need to be able to follow up with a stat=
 or equivalent.<br>
&gt;&gt;&gt; &gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt; Yes, but one of the main such applications is the &q=
uot;find&quot; utility,<br>
&gt;&gt;&gt; &gt; &gt; which<br>
&gt;&gt;&gt; &gt; &gt; uses it to avoid calling stat() in order to discover=
 the<br>
&gt;&gt;&gt; &gt; &gt; directories.<br>
&gt;&gt;&gt; &gt; &gt; For that reason, NFS does try to set the d_type flag=
 when it is<br>
&gt;&gt;&gt; &gt; &gt; using<br>
&gt;&gt;&gt; &gt; &gt; readdirplus, and the server returns attributes for t=
he entry in<br>
&gt;&gt;&gt; &gt; &gt; question. Otherwise, it is forced to default to DT_U=
NKNOWN.<br>
&gt;&gt;&gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; Yes, didn&#39;t mean to imply that we shouldn&#39;t try t=
o fill these out<br>
&gt;&gt;&gt; &gt; where<br>
&gt;&gt;&gt; &gt; we can, just that there are situations where we might not=
 be able<br>
&gt;&gt;&gt; &gt; to do<br>
&gt;&gt;&gt; &gt; so without taking a performance hit.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; &gt; Note that in the cases where the readdir entry has a=
 matching<br>
&gt;&gt;&gt; &gt; &gt; dentry,<br>
&gt;&gt;&gt; &gt; &gt; we probably could try to do better by doing a d_look=
up() and then<br>
&gt;&gt;&gt; &gt; &gt; filling the d_type. Is that worth doing?<br>
&gt;&gt;&gt; &gt; &gt;<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; I like that idea. Filling out what info we can from the l=
ocal cache<br>
&gt;&gt;&gt; &gt; is<br>
&gt;&gt;&gt; &gt; almost always worthwhile.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt; &gt; An inode&#39;s d_type can never change, so you can just v=
et the fileid<br>
&gt;&gt;&gt; &gt; or fh<br>
&gt;&gt;&gt; &gt; in the entry3 vs. the inode that comes back from d_lookup=
. If they<br>
&gt;&gt;&gt; &gt; match<br>
&gt;&gt;&gt; &gt; then you can reliably fill that out.<br>
&gt;&gt;&gt; &gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Ironically, this is where NFS over overlayfs may fail, because=
 in<br>
&gt;&gt;&gt; overlayfs<br>
&gt;&gt;&gt; d_ino is not always consistent with st_ino. Since v4.15, d_ino=
 is<br>
&gt;&gt;&gt; consistent<br>
&gt;&gt;&gt; with st_ino for the case of all layers on the same filesystem.=
 I<br>
&gt;&gt;&gt; already posted<br>
&gt;&gt;&gt; a POC for fixing d_ino/st_ino for non-samefs, but it never got=
<br>
&gt;&gt;&gt; merged.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; What puzzles me w.r.t. this &quot;nonbug&quot; report is that =
I don&#39;t<br>
&gt;&gt;&gt; understand why<br>
&gt;&gt;&gt; NFS over overlayfs would behave differently vs. NFS over local=
 fs.<br>
&gt;&gt;&gt; I am hoping it does not point to a different problem, so would=
 love<br>
&gt;&gt;&gt; to<br>
&gt;&gt;&gt; get a more detailed analysis of what&#39;s going on between nf=
sd and<br>
&gt;&gt;&gt; overlayfs.<br>
&gt;&gt;<br>
&gt;&gt; The behaviour being described is true of the regular NFS client. I=
t has<br>
&gt;&gt; nothing to do with overlayfs.<br>
&gt;&gt;<br>
&gt;<br>
&gt; Here:<br>
&gt; <a href=3D"https://marc.info/?l=3Dlinux-unionfs&amp;m=3D15209305020435=
7&amp;w=3D2" rel=3D"noreferrer noreferrer" target=3D"_blank">https://marc.i=
nfo/?l=3Dlinux-unionfs&amp;m=3D152093050204357&amp;w=3D2</a><br>
&gt;<br>
&gt; Eddie claims that the observed DT_UNKNOWN issue is reproduced<br>
&gt; with NFSv3 over overlayfs and NOT with NFSv3 over ext4.<br>
&gt;<br>
&gt; That&#39;s the only fact I find puzzling.<br>
&gt;<br>
&gt; But I did not see a confirmation that this is a reproducible problem<b=
r>
&gt; with exact same directory and I did not try to reproduce it myself.<br=
>
&gt;<br>
&gt; Thanks,<br>
&gt; Amir.<br>
</blockquote></div>

--94eb2c03cef4b56eff0567700c98--

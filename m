Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Mon, 12 Mar 2018 15:13:53 +0800
Message-ID: <CALLuPvrEfoMPxqC3n=KovgV7DBo3pMtLK8VaFV7yWOmiFsZSDw@mail.gmail.com>
Subject: flock fails in overlay nfs-exported file
Content-Type: multipart/alternative; boundary="001a1134f94e794323056731e214"
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

--001a1134f94e794323056731e214
Content-Type: text/plain; charset="UTF-8"

Hello Miklos,
I'd like to report a flock(2) problem to overlay nfs-exported files. The
error return from flock(2) is "Bad file descriptor".

Environment:
OS: Ubuntu 14.04.2 LTS
Kernel: 4.16.0-041600rc4-generic (from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/)

Reproduce step:
(nfs server side)
mount -t overlay
-orw,lowerdir=/mnt/ro,upperdir=/mnt/u,workdir=/mnt/w,nfs_export=on,index=on
none /mnt/m
touch /mnt/m/foo
(nfs client side)
mount server:/mnt/m /mnt/n

flock /mnt/n/foo
failed to lock file '/mnt/n/foo': Bad file descriptor

The simple flock(2) wrap program is:
int main(int argc, void **argv) {
char *filename=argv[1];
int fd = open(filename, O_RDONLY);;
int flock_result = flock(fd, LOCK_EX | LOCK_NB);
if (flock_result != 0) {
      printf("failed to lock file '%s': %s\n", filename, strerror(errno));
      goto out;
    }
    printf("flock succeed\n");
out:
    close(fd);
}

Thanks!

--001a1134f94e794323056731e214
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello=C2=A0Miklos,<div>I&#39;d like to report a flock(2) p=
roblem to=C2=A0overlay nfs-exported files. The error return from flock(2) i=
s &quot;Bad file descriptor&quot;.</div><div><br></div><div>Environment:</d=
iv><div>OS:=C2=A0Ubuntu 14.04.2 LTS</div><div>Kernel:=C2=A04.16.0-041600rc4=
-generic (from=C2=A0<a href=3D"http://kernel.ubuntu.com/~kernel-ppa/mainlin=
e/v4.16-rc4/">http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.16-rc4/</a>)=
</div><div><br></div><div>Reproduce step:</div><div>(nfs server side)</div>=
<div>mount -t overlay -orw,lowerdir=3D/mnt/ro,upperdir=3D/mnt/u,workdir=3D/=
mnt/w,nfs_export=3Don,index=3Don none /mnt/m<br></div><div>touch /mnt/m/foo=
</div><div>(nfs client side)</div><div>mount server:/mnt/m /mnt/n<br></div>=
<div><br></div><div>flock /mnt/n/foo</div><div>failed to lock file &#39;/mn=
t/n/foo&#39;: Bad file descriptor<br></div><div><br></div><div>The simple f=
lock(2) wrap program is:</div><div><div>int main(int argc, void **argv) {</=
div><div><span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</=
span>char *filename=3Dargv[1];</div><div><span class=3D"gmail-Apple-tab-spa=
n" style=3D"white-space:pre">	</span>int fd =3D open(filename, O_RDONLY);;<=
/div><div><span class=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	<=
/span>int flock_result =3D flock(fd, LOCK_EX | LOCK_NB);</div><div><span cl=
ass=3D"gmail-Apple-tab-span" style=3D"white-space:pre">	</span>if (flock_re=
sult !=3D 0) {</div><div>=C2=A0 =C2=A0 =C2=A0 printf(&quot;failed to lock f=
ile &#39;%s&#39;: %s\n&quot;, filename, strerror(errno));</div><div>=C2=A0 =
=C2=A0 =C2=A0 goto out;</div><div>=C2=A0 =C2=A0 }</div><div>=C2=A0 =C2=A0 p=
rintf(&quot;flock succeed\n&quot;);</div><div>out: =C2=A0 =C2=A0</div><div>=
=C2=A0 =C2=A0 close(fd);</div><div>}</div></div><div><br></div><div>Thanks!=
</div></div>

--001a1134f94e794323056731e214--

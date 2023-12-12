Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ULRIiX7N"
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57963EA
	for <linux-unionfs@vger.kernel.org>; Tue, 12 Dec 2023 11:20:00 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-590a2a963baso2391521eaf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Dec 2023 11:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702408799; x=1703013599; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDZO9rUEaSCIKGPTNLQORxAuPrrJryJu9QjeOQcq1A4=;
        b=ULRIiX7NQXM5WPHI3stffAwtHpawpC++J7zI5HHwtWwZGetYluDUHaPZwz0/hg0gn8
         2K2MK2IvA+P7jZGRS5uhbJ/tFXLg2Nkw9XOFNmgqIbmJe4CMBBFaowB9AOQ60dFCcB8q
         +CmEeFEtIcctb8A3ltc+uNotzk5BKlv9l8WACyONkuvQbZRIbfAb3ZZYlHKYXeXeBjZM
         NN1EtyRt434GQNQtkDlw6wGzVhKd1jjbVuT/Wi8gGWEuAhOVHrEpROmgGt9vDaOpciEL
         5ZHMygSMGAE3wGLqNgsIQwT/OeJ7dd8An0XYfRPFTP3WN50b58RVTmWUMbVb6f8a8Cmt
         bKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702408799; x=1703013599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDZO9rUEaSCIKGPTNLQORxAuPrrJryJu9QjeOQcq1A4=;
        b=oko9TBv4lQtK94HsE5MQRQRI8bvjnXEpspAnRxhkWzfJ0IC+dzIp5krm9yw5TkRY3n
         Ys2fLiq2dtA9+ts2M0tIOenDr30miJLjXURlrgGibqdNuPSgoBQPfMoJGV0KwJ+b6F9K
         ZDSlt2TYW5A5CwWKwMnIwU70nJau0viGhZZjivz6dyHnObMalD8QQ09zCj/X6hapH1KJ
         zbRGiFtd76l0JBtXci0YxTsuF+WL9j+wj+t4QxLtMtPiZGym7Wmw2j1ptrzbckcooUFd
         CrjmKQiY/haK+rQ9MPp7VNpN+fCppOdM5TNi9hj7Mf04n/wKyBZHuK8cBwrq6NY6YIaG
         d+2g==
X-Gm-Message-State: AOJu0Yy63xePOR3FKMusFzqmv7PcNVOHY5E5AJNljadpThw0mFZC1e8d
	xDRxBbMe2Hu5ev9o8wlVfKc0L9lH+Q6QpzDJWCP0XA==
X-Google-Smtp-Source: AGHT+IHhHldkkKWSw5/c1UASxLGabkICfwtszvf2fhz0+qfzxSM9eqL1W0JVD3z3i8kQ+OE2shxpMKk0DM9YNWaT9QU=
X-Received: by 2002:a4a:1d86:0:b0:58e:1c47:879b with SMTP id
 128-20020a4a1d86000000b0058e1c47879bmr4535569oog.16.1702408799400; Tue, 12
 Dec 2023 11:19:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231211193048.580691-1-avagin@google.com> <CAOQ4uxik0=0F-6CLRsuaOheFjwWF-B-Q5iEQ6qJbRszL52HeQQ@mail.gmail.com>
 <20231212-brokkoli-trinken-1581d1e99d6a@brauner>
In-Reply-To: <20231212-brokkoli-trinken-1581d1e99d6a@brauner>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 12 Dec 2023 11:19:48 -0800
Message-ID: <CAEWA0a6AzM0xLGW+_iFV11h8acqSZ3MfQuivf_inSjR+veh1Ng@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/proc: show correct device and inode numbers in /proc/pid/maps
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 1:27=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Dec 12, 2023 at 07:51:31AM +0200, Amir Goldstein wrote:
> > +fsdevel, +overlayfs, +brauner, +miklos
> >
> > On Mon, Dec 11, 2023 at 9:30=E2=80=AFPM Andrei Vagin <avagin@google.com=
> wrote:
> > >
> > > Device and inode numbers in /proc/pid/maps have to match numbers retu=
rned by
> > > statx for the same files.
> >
> > That statement may be true for regular files.
> > It is not true for block/char as far as I know.
> >
> > I think that your fix will break that by displaying the ino/dev
> > of the block/char reference inode and not their backing rdev inode.
> >
> > >
> > > /proc/pid/maps shows device and inode numbers of vma->vm_file-s. Here=
 is
> > > an issue. If a mapped file is on a stackable file system (e.g.,
> > > overlayfs), vma->vm_file is a backing file whose f_inode is on the
> > > underlying filesystem. To show correct numbers, we need to get a user
> > > file and shows its numbers. The same trick is used to show file paths=
 in
> > > /proc/pid/maps.
> >
> > For the *same* trick, see my patch below.
> >
> > >
> > > But it isn't the end of this story. A file system can manipulate inod=
e numbers
> > > within the getattr callback (e.g., ovl_getattr), so vfs_getattr must =
be used to
> > > get correct numbers.
> >
> > This explanation is inaccurate, because it mixes two different overlayf=
s
> > traits which are unrelated.
> > It is true that a filesystem *can* manipulate st_dev in a way that will=
 not
> > match i_ino and it is true that overlayfs may do that in some non-defau=
lt
> > configurations (see [1]), but this is not the reason that you are seein=
g
> > mismatches ino/dev in /proc/<pid>/maps.
> >
> > [1] https://docs.kernel.org/filesystems/overlayfs.html#inode-properties
> >
> > The reason is that the vma->vm_file is a special internal backing file
> > which is not otherwise exposed to userspace.
> > Please see my suggested fix below.
> >
> > >
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > > Signed-off-by: Andrei Vagin <avagin@google.com>
> > > ---
> > >  fs/proc/task_mmu.c | 20 +++++++++++++++++---
> > >  1 file changed, 17 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 435b61054b5b..abbf96c091ad 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -273,9 +273,23 @@ show_map_vma(struct seq_file *m, struct vm_area_=
struct *vma)
> > >         const char *name =3D NULL;
> > >
> > >         if (file) {
> > > -               struct inode *inode =3D file_inode(vma->vm_file);
> > > -               dev =3D inode->i_sb->s_dev;
> > > -               ino =3D inode->i_ino;
> > > +               const struct path *path;
> > > +               struct kstat stat;
> > > +
> > > +               path =3D file_user_path(file);
> > > +               /*
> > > +                * A file system can manipulate inode numbers within =
the
> > > +                * getattr callback (e.g. ovl_getattr).
> > > +                */
> > > +               if (!vfs_getattr_nosec(path, &stat, STATX_INO, AT_STA=
TX_DONT_SYNC)) {
> >
> > Should you prefer to keep this solution it should be constrained to
> > regular files.
>
> It's also very dicy calling into the filesystem from procfs. You might
> hang the system if you end up talking to a hung NFS server or something.
> What locks does show_map_vma() hold? And is it safe to call helpers that
> might generate io?

I had the same thoughts when I was thinking about whether it is safe
to use it here
or not. Then I found AT_STATX_DONT_SYNC (don't sync attributes with
the server) and
decided that it should be safe. Anyway, Amir explains that
vfs_getattr_nosec isn't
needed for overlay files.

Thanks,
Andrei

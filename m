Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191222184528.32687-1-amir73il@gmail.com> <2f6dbf1777ae4b9870c077b8a34c79bf8ed8a554.camel@kernel.org>
In-Reply-To: <2f6dbf1777ae4b9870c077b8a34c79bf8ed8a554.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Dec 2019 04:58:40 +0200
Message-ID: <CAOQ4uxgJZORnBoGe=UA3j=8sfBeccv07vQes0Q9RjSVXKGrKhw@mail.gmail.com>
Subject: Re: [PATCH] locks: print unsigned ino in /proc/locks
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@kernel.org>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Dec 23, 2019 at 3:17 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Sun, 2019-12-22 at 20:45 +0200, Amir Goldstein wrote:
> > An ino is unsigned so export it as such in /proc/locks.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Hi Jeff,
> >
> > Ran into this while writing tests to verify i_ino == d_ino == st_ino on
> > overlayfs. In some configurations (xino=on) overlayfs sets MSB on i_ino,
> > so /proc/locks reports negative ino values.
> >
> > BTW, the requirement for (i_ino == d_ino) came from nfsd v3 readdirplus.
> >
> > Thanks,
> > Amir.
> >
> >  fs/locks.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 6970f55daf54..44b6da032842 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -2853,7 +2853,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >       }
> >       if (inode) {
> >               /* userspace relies on this representation of dev_t */
> > -             seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
> > +             seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
> >                               MAJOR(inode->i_sb->s_dev),
> >                               MINOR(inode->i_sb->s_dev), inode->i_ino);
> >       } else {
>
> My that is an old bug! I think that goes back to early v2.x days, if not
> v1.x. I'll queue it up, and maybe we can get this in for v5.6.

I suppose you meant for v5.5?
I'd be happy if we can also mark it for stable (sorry I did not).
Reason is that I have xfstests depending on it, which test overlay
fixes that are marked for stable.

Thanks,
Amir.

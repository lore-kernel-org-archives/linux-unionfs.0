Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181024195837.35532-1-olga.kornievskaia@gmail.com>
 <20181024195837.35532-6-olga.kornievskaia@gmail.com> <CAOQ4uxg4_eF2_uur7-S=SCc5QzyVUfqRBjr9yYDGLsq5Ai4GXA@mail.gmail.com>
 <CAN-5tyH2PiBUP0Si1pJsMbf8WARUG9rVoAr07oPbZ=CQuwg3Lw@mail.gmail.com> <CAOQ4uxiUpLgoBP1hQuQkKptJiOTATm_C9u7w1-kvqaNuqAT_2Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxiUpLgoBP1hQuQkKptJiOTATm_C9u7w1-kvqaNuqAT_2Q@mail.gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Thu, 25 Oct 2018 13:12:20 -0400
Message-ID: <CAN-5tyHgfJLHW1zqpf4eU8OV1bn0wFuCn03rvzA=pe9giPJdUg@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] NFS: add cross file system check for copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 12:54 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Oct 25, 2018 at 6:28 PM Olga Kornievskaia
> <olga.kornievskaia@gmail.com> wrote:
> >
> > On Thu, Oct 25, 2018 at 12:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Wed, Oct 24, 2018 at 10:59 PM Olga Kornievskaia
> > > <olga.kornievskaia@gmail.com> wrote:
> > > >
> > > > From: Olga Kornievskaia <kolga@netapp.com>
> > > >
> > > > VFS copy_file_range was relaxed to allow for cross-device copy.
> > > > Add a check to disallow cross file systems copy offload, both
> > > > files are expected to be of NFS type.
> > > >
> > > > Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> > > > ---
> > > >  fs/nfs/nfs4file.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> > > > index 4288a6e..7137e7b 100644
> > > > --- a/fs/nfs/nfs4file.c
> > > > +++ b/fs/nfs/nfs4file.c
> > > > @@ -135,6 +135,9 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
> > > >  {
> > > >         ssize_t ret;
> > > >
> > > > +       if (file_in->f_inode->i_sb->s_type != file_out->f_inode->i_sb->s_type)
> > > > +               return -EXDEV;
> > > > +
> > >
> > > You would need to doo  the patches in following order:
> > > 1. add same sb check in nfs
> > > 2. relax same sb check in vfs
> > > 3. implement cross fs copy in nfs
> > > 4. relax same sb to same sb type in nfs
> >
> > Thank you, I will reorder the patches.
> >
>
> On second thought, It's probably best to do #1 (for nfs, cifs, ovl) + #2
> in the same patch, to prevent someone from backporting just #2
> without #1.
>
> Let me know if this was too cryptic.

Thank you I think I understood.

In an unsubmitted version I had a single VFS patch that made the VFS
change and included the checks for the file systems. However, I
thought maybe it wasn't appropriate to have FS changes and VFS changes
in the same patch and thus I split them up. Since you say it's
actually preferred I will do so. Do I need to change the title from
just "VFS" to somehow indicate that it has NFS/CIFS/Overlayfs content?
Or is the current title ok?



>
> Thanks,
> Amir.

Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190402193155.27555-1-amir73il@gmail.com> <20190403204612.GC19929@redhat.com>
In-Reply-To: <20190403204612.GC19929@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Apr 2019 07:41:04 +0300
Message-ID: <CAOQ4uxgfWqDM8Ae5iLJcYrObhV15OKieB0FG5u09i-WHSc6Cow@mail.gmail.com>
Subject: Re: [PATCH] ovl: detect overlapping layers
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 3, 2019 at 11:46 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Apr 02, 2019 at 10:31:55PM +0300, Amir Goldstein wrote:
> [..]
> >  /*
> >   * Does overlay inode need to be hashed by lower inode?
> >   */
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index efd372312ef1..badf039267a2 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -18,6 +18,7 @@
> >  #include "overlayfs.h"
> >
> >  struct ovl_lookup_data {
> > +     struct super_block *sb;
> >       struct qstr name;
> >       bool is_dir;
> >       bool opaque;
> > @@ -244,6 +245,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >               if (!d->metacopy || d->last)
> >                       goto out;
> >       } else {
> > +             if (ovl_lookup_trap_inode(d->sb, this)) {
> > +                     /* Caught in a trap of overlapping layers */
> > +                     err = -ELOOP;
> > +                     goto out_err;
> > +             }
> > +
>
> Hi Amir,
>
> This idea of putting dummy inodes in overlay inode cache hashed by inode
> pointer of root inode of underlying layers seems very clever. Cost
> of checking overlapping layer also seems to be O(N) and that's good.
>
> So if we want to detect this case of overlapping layers after the mount,
> then we have to pay the cost of this trap inode lookup for every dentry
> found in upper/lower layer
>

Doesn't seem so expensive compared to overlay directory lookup, even in
the best case of upper/lower layer dentry in dcache.

> [..]
> > +static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
> > +                       struct inode **ptrap, const char *name)
> > +{
> > +     struct inode *trap;
> > +     int err;
> > +
> > +     trap = ovl_get_trap_inode(sb, dir);
> > +     err = PTR_ERR(trap);
> > +     if (IS_ERR(trap)) {
> > +             pr_err("overlayfs: conflicting %s path (%i)\n", name, err);
> > +             return err;
> > +     }
> > +
>
> ovl_get_trap_inode() can fail for other reasons like -ENOMEM. Should we
> warn about conflicting path only on -EEXIST.
>

Agreed.

> [..]
> >  static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >  {
> >       struct path upperpath = { };
> > @@ -1457,17 +1552,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >       if (ofs->config.xino != OVL_XINO_OFF)
> >               ofs->xino_bits = BITS_PER_LONG - 32;
> >
> > +     /* alloc/destroy_inode needed for setting up traps in inode cache */
> > +     sb->s_op = &ovl_super_operations;
> > +
>
> Passing super block pointer to routines outside overlay before sb
> initializaiton is complete, is it safe?
>

It ain't pretty, but as far as calling vfs inode helpers,
d_make_root(ovl_new_inode(sb, ...
below does the same with only "slightly more" initialized sb.

I could do more of the sb initialization at this point.
In fact, setting sb->s_fs_info = ofs, at this point could save passing
both sb and ofs to ovl_fill_super() helpers.

One more thing about order of sanity tests -
It would have been nice if ovl_verify_origin() was done after
ovl_check_overlapping_layers(). As it is, when mounting with
overlapping layers, we first store fh of overlapping lower in
upper root xattr and only then fail the mount, leaving the
upper dir unusable for another mount try.
I had to take special care of this case in the xfstest:
https://github.com/amir73il/xfstests/blob/overlayfs-devel/tests/overlay/065#L60

However, I've decided that this is a corner case not worth complicating
the code over. Something that could be left for fsck.overlay.

Thanks,
Amir.

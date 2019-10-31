Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191030124431.11242-1-cgxu519@mykernel.net> <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
 <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
In-Reply-To: <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 31 Oct 2019 08:53:15 +0200
Message-ID: <CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse file
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

>  > Yes, overlayfs does not comply with this "posix"' test.
>  > This is why it was removed from the auto and quick groups.
>
> So I'm curious what is the purpose for the test?
>

This is a POSIX compliance test.
It is meant to "remind" us that this behavior is not POSIX compliant
and that we should fix it one day...
A bit controversial to have a test like this without a roadmap
when it is going to be fixed in xfstests, but it's there.

>  >
>  > >
>  > >
>  > > v1->v2:
>  > > - Set file size when the hole is in the end of the file.
>  > > - Add a code comment for hole copy-up improvement.
>  > > - Check SEEK_DATA support before doing hole skip.
>  > > - Back to original copy-up when seek data fails(in error case).
>  > >
>  > >  fs/overlayfs/copy_up.c | 78 ++++++++++++++++++++++++++++++++++--------
>  > >  1 file changed, 64 insertions(+), 14 deletions(-)
>  > >
>  > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>  > > index b801c6353100..7d8a34c480f4 100644
>  > > --- a/fs/overlayfs/copy_up.c
>  > > +++ b/fs/overlayfs/copy_up.c
>  > > @@ -116,13 +116,30 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
>  > >         return error;
>  > >  }
>  > >
>  > > -static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  > > +static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
>  > > +{
>  > > +       struct iattr attr = {
>  > > +               .ia_valid = ATTR_SIZE,
>  > > +               .ia_size = stat->size,
>  > > +       };
>  > > +
>  > > +       return notify_change(upperdentry, &attr, NULL);
>  > > +}
>  > > +
>  > > +static int ovl_copy_up_data(struct path *old, struct path *new,
>  > > +                           struct kstat *stat)
>  > >  {
>  > >         struct file *old_file;
>  > >         struct file *new_file;
>  > > +       loff_t len = stat->size;
>  > >         loff_t old_pos = 0;
>  > >         loff_t new_pos = 0;
>  > >         loff_t cloned;
>  > > +       loff_t old_next_data_pos;
>  > > +       loff_t hole_len;
>  > > +       bool seek_support = false;
>  > > +       bool skip_hole = true;
>  > > +       bool set_size = false;
>  > >         int error = 0;
>  > >
>  > >         if (len == 0)
>  > > @@ -144,7 +161,12 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  > >                 goto out;
>  > >         /* Couldn't clone, so now we try to copy the data */
>  > >
>  > > -       /* FIXME: copy up sparse files efficiently */
>  > > +       /* Check if lower fs supports seek operation */
>  > > +       if (old_file->f_mode & FMODE_LSEEK &&
>  > > +           old_file->f_op->llseek) {
>  > > +               seek_support = true;
>  > > +       }
>  > > +
>  > >         while (len) {
>  > >                 size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
>  > >                 long bytes;
>  > > @@ -157,6 +179,38 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  > >                         break;
>  > >                 }
>  > >
>  > > +               /*
>  > > +                * Fill zero for hole will cost unnecessary disk space
>  > > +                * and meanwhile slow down the copy-up speed, so we do
>  > > +                * an optimization for hole during copy-up, it relies
>  > > +                * on SEEK_DATA implementation and the hole check is
>  > > +                * aligned to OVL_COPY_UP_CHUNK_SIZE. In other word,
>  > > +                * we do not try to recognize all kind of holes here,
>  > > +                * we just skip big enough hole for simplicity to
>  > > +                * implement. If lower fs does not support SEEK_DATA
>  > > +                * operation, the copy-up will behave as before.
>  > > +                */
>  > > +
>  > > +               if (seek_support && skip_hole) {
>  > > +                       old_next_data_pos = vfs_llseek(old_file,
>  > > +                                               old_pos, SEEK_DATA);
>  > > +                       if (old_next_data_pos >= old_pos +
>  > > +                                               OVL_COPY_UP_CHUNK_SIZE) {
>  > > +                               hole_len = (old_next_data_pos - old_pos) /
>  > > +                                               OVL_COPY_UP_CHUNK_SIZE *
>  > > +                                               OVL_COPY_UP_CHUNK_SIZE;
>  >
>  > Use round_down() helper
>
> I'll change the logic of hole detection a bit, so that it could work
> more effectively for big continuous hole.

Not sure what you mean.
I meant there is a helper in the kernel you should use
instead of the expression "/ N * N"

>
>
>  >
>  > > +                               old_pos += hole_len;
>  > > +                               new_pos += hole_len;
>  > > +                               len -= hole_len;
>  > > +                               continue;
>  > > +                       } else if (old_next_data_pos == -ENXIO) {
>  > > +                               set_size = true;
>  > > +                               break;
>  > > +                       } else if (old_next_data_pos < 0) {
>  > > +                               skip_hole = false;
>  >
>  > Why do you need to use 2 booleans?
>  > You can initialize skip_hole = true only in case of lower
>  > has seek support.
>  >
>  > >
>  > > +                       }
>  > > +               }
>  > > +
>  > >                 bytes = do_splice_direct(old_file, &old_pos,
>  > >                                          new_file, &new_pos,
>  > >                                          this_len, SPLICE_F_MOVE);
>  > > @@ -168,6 +222,12 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>  > >
>  > >                 len -= bytes;
>  > >         }
>  > > +
>  > > +       if (!error && set_size) {
>  > > +               inode_lock(new->dentry->d_inode);
>  > > +               error = ovl_set_size(new->dentry, stat);
>  > > +               inode_unlock(new->dentry->d_inode);
>  > > +       }
>  >
>  > I see no reason to repeat this code here.
>  > Two options:
>  > 1. always set_size at the end of ovl_copy_up_inode()
>  >     what's the harm in that?
>
> I think at least it's not suitable for directory.
>
>
>  > 2. set boolean c->set_size here and check it at the end
>  >     of ovl_copy_up_inode() instead of checking c->metacopy
>  >
>
> I don't understand why 'c->set_size' can replace 'c->metacopy',
>

I did not explain myself well.

This should be enough IMO:

@@ -483,7 +483,7 @@ static int ovl_copy_up_inode(struct
ovl_copy_up_ctx *c, struct dentry *temp)
        }

        inode_lock(temp->d_inode);
-       if (c->metacopy)
+       if (S_ISREG(c->stat.mode))
                err = ovl_set_size(temp, &c->stat);
        if (!err)
                err = ovl_set_attr(temp, &c->stat);

There is no special reason IMO to try to spare an unneeded ovl_set_size
if it simplifies the code a bit.

As a matter of fact, I think overlayfs currently does a metacopy
copy up even for files of size 0.
This will cost unneeded code to run during lookup and later
for clearing the metacopy on "data" copy up.
Not sure how much this case is common,
but that's for another patch:

@@ -717,7 +717,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
        return err;
 }

-static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
+static bool ovl_need_meta_copy_up(struct dentry *dentry, struct kstat *stat,
                                  int flags)
 {
        struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
@@ -725,7 +725,7 @@ static bool ovl_need_meta_copy_up(struct dentry
*dentry, umode_t mode,
        if (!ofs->config.metacopy)
                return false;

-       if (!S_ISREG(mode))
+       if (!S_ISREG(stat->mode) || !stat->size)
                return false;

        if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
@@ -805,7 +805,7 @@ static int ovl_copy_up_one(struct dentry *parent,
struct dentry *dentry,
        if (err)
                return err;

-       ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
+       ctx.metacopy = ovl_need_meta_copy_up(dentry, &ctx.stat, flags);

        if (parent) {
                ovl_path_upper(parent, &parentpath);

Thanks,
Amir.

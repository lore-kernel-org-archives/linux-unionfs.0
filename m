Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <12c81a49-efca-d66c-2143-ae04ca248cce@suse.de> <1545174031.4178.8.camel@linux.ibm.com>
 <1545233975.3954.8.camel@linux.ibm.com> <CAOQ4uxgoMntXsxnsxtBOOPLDo3HgcYPWayuCuDzxEx2GJSMZtg@mail.gmail.com>
 <1545244479.3954.38.camel@linux.ibm.com>
In-Reply-To: <1545244479.3954.38.camel@linux.ibm.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 19 Dec 2018 22:39:50 +0200
Message-ID: <CAOQ4uxiGoOsON9E6b53DAtPo=JJHx6FT0NiksGdxkeU886JB3A@mail.gmail.com>
Subject: Re: EVM: Permission denied with overlayfs
Content-Type: text/plain; charset="UTF-8"
To: zohar@linux.ibm.com
Cc: iforster@suse.de, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> > Hi Mimi,
> >
> > v4.19 has a big change that removes many VFS hacks in favor of
> > overlayfs stacked file operations.
> >
> > The major implication for VFS code is that file_inode(file) is now the overlayfs
> > inode and not the real inode. Therefore, file_dentry(file) is also the overlayfs
> > dentry and not the real dentry.
> >
> > I am not sure how that change impacts EVM ?
> > FWIW, d_backing_inode(dentry) was never anything more than d_inode(dentry).
> >
> > Can you please try to describe in more details for someone who has no clue what
> > EVM does how exactly the v4.19 change is manifested in the EVM use case.
>
> IMA calculates and stores a file hash/signature on the file data
> (security.ima).  EVM calculates and stores an HMAC/signature on the
> file metadata (security.evm).  Some data needs to be included in the
> HMAC/signature that binds the file metadata with the file data.  That
> data is the inode's ino, generation, uid, gid, mode and the uuid.
>
> >
> > AFAIKT, evm_calc_hmac_or_hash() would get the overlayfs dentry both in
> > v4.18 and v4.19 and therefore d_backing_inode(dentry) should be the
> > overlayfs inode in both kernels (?).
> >
> > The value of overlayfs inode i_ino can be identical to i_ino of the real inode
> > under some conditions, but far from always and the value of overlayfs inode
> > i_generation is almost guaranteed to not match that of the real inode.
> >
> > Ignaz, can you add some more debug prints to shed some light on what
> > exactly has changed, between the two kernels?
> > If the calculated hashes do not match in two different execution paths,
> > please provide two sample stack traces that see different i_ino, so we can
> > examine them.
>
> Assuming you've created and overlay mounted the lower, upper, work,
> and merged directories, accessing files only in the merged directory
> fails.
>

Mimi,

I think I understand the problem I just don't see how that use case could have
ever worked with overlayfs.
The following patch may make your test pass,
but #1: I am not sure it is safe to do that without ovl_index_all() -
need to think about implications
but #2: For some overlayfs setups that won't be enough to
guaranty consistent i_ino
but #3: Not sure about the role of i_generation

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 30ef69715a81..8d8cd6acd71e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -560,8 +560,7 @@ static void ovl_fill_inode(struct inode *inode,
umode_t mode, dev_t rdev,
         * ovl_new_inode(), ino arg is 0, so i_ino will be updated to real
         * upper inode i_ino on ovl_inode_init() or ovl_inode_update().
         */
-       if (inode->i_sb->s_export_op &&
-           (ovl_same_sb(inode->i_sb) || xinobits)) {
+       if ((ovl_same_sb(inode->i_sb) || xinobits)) {
                inode->i_ino = ino;
                if (xinobits && fsid && !(ino >> (64 - xinobits)))
                        inode->i_ino |= (unsigned long)fsid << (64 - xinobits);

Thanks,
Amir.

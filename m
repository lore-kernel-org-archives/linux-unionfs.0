Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpeguaR0u=JL_ZwAv2cTX3jcwWDPDJ-uk6Fhxua_5BnK8Cww@mail.gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
 <1522333133-24772-4-git-send-email-amir73il@gmail.com> <CAJfpegtbvrTTnaoB8k9USp_Ev_PWA64efnaEt+JC_rdYU1sfWg@mail.gmail.com>
 <CAOQ4uxiPB5BB8Wm=qe=HPohDqVMiwFy2niWa5vstgc0Y=nRhyg@mail.gmail.com> <CAJfpeguaR0u=JL_ZwAv2cTX3jcwWDPDJ-uk6Fhxua_5BnK8Cww@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 22:02:29 +0300
Message-ID: <CAOQ4uxgg+ntFoFh9zaPP2Xi-0dw-UfCvNawgAptFEN0gVCzQ-Q@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] ovl: constant st_ino for non-samefs with xino
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 9:26 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Mar 29, 2018 at 6:42 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Mar 29, 2018 at 6:58 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Thu, Mar 29, 2018 at 4:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> On 64bit systems, when overlay layers are not all on the same fs, but
>>>> all inode numbers of underlying fs are not using the high bits, use the
>>>> high bits to partition the overlay st_ino address space.  The high bits
>>>> hold the fsid (upper fsid is 0).  This way overlay inode numbers are unique
>>>> and all inodes use overlay st_dev.  Inode numbers are also persistent
>>>> for a given layer configuration.
>>>>
>>>> Currently, our only indication for available high ino bits is from a
>>>> filesystem that supports file handles and uses the default encode_fh()
>>>> operation, which encodes a 32bit inode number.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
>>>>  fs/overlayfs/inode.c     | 31 +++++++++++++++++++++++++++++--
>>>>  fs/overlayfs/overlayfs.h |  3 ++-
>>>>  fs/overlayfs/ovl_entry.h |  2 ++
>>>>  fs/overlayfs/super.c     | 26 ++++++++++++++++++++++----
>>>>  fs/overlayfs/util.c      | 24 +++++++++++++++++++++---
>>>>  5 files changed, 76 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>>>> index 89dfab20fe0e..7fc9c83bf2ff 100644
>>>> --- a/fs/overlayfs/inode.c
>>>> +++ b/fs/overlayfs/inode.c
>>>> @@ -63,6 +63,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
>>>>  {
>>>>         struct ovl_layer *lower_layer = ovl_layer_lower(dentry);
>>>>         bool samefs = ovl_same_sb(dentry->d_sb);
>>>> +       int xinobits = ovl_xino_bits(dentry->d_sb);
>>>>
>>>>         if (samefs) {
>>>>                 /*
>>>> @@ -71,7 +72,31 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
>>>>                  * which is friendly to du -x.
>>>>                  */
>>>>                 stat->dev = dentry->d_sb->s_dev;
>>>> -       } else if (S_ISDIR(dentry->d_inode->i_mode)) {
>>>> +               return 0;
>>>> +       } else if (xinobits) {
>>>> +               /*
>>>> +                * All inode numbers of underlying fs should not be using the
>>>> +                * high xinobits, so we use high xinobits to partition the
>>>> +                * overlay st_ino address space. The high bits holds the fsid
>>>> +                * (upper fsid is 0). This way overlay inode numbers are unique
>>>> +                * and all inodes use overlay st_dev. Inode numbers are also
>>>> +                * persistent for a given layer configuration.
>>>> +                */
>>>> +               if (stat->ino >> (64 - xinobits)) {
>>>> +                       pr_warn_ratelimited("overlayfs: inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
>>>> +                                           dentry, stat->ino, xinobits);
>>>> +               } else {
>>>> +                       if (lower_layer) {
>>>> +                               stat->ino |= ((u64)lower_layer->fsid)
>>>> +                                            << (64 - xinobits);
>>>> +                       }
>>>> +                       stat->dev = dentry->d_sb->s_dev;
>>>> +                       return 0;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       /* The inode could not be mapped to a unified st_ino address space */
>>>> +       if (S_ISDIR(dentry->d_inode->i_mode)) {
>>>>                 /*
>>>>                  * Always use the overlay st_dev for directories, so 'find
>>>>                  * -xdev' will scan the entire overlay mount and won't cross the
>>>> @@ -117,11 +142,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>>>>         /*
>>>>          * For non-dir or same fs, we use st_ino of the copy up origin.
>>>>          * This guaranties constant st_dev/st_ino across copy up.
>>>> +        * With xino feature and non-samefs, we use st_ino of the copy up
>>>> +        * origin masked with high bits that represent the layer id.
>>>>          *
>>>>          * If lower filesystem supports NFS file handles, this also guaranties
>>>>          * persistent st_ino across mount cycle.
>>>>          */
>>>> -       if (!is_dir || samefs) {
>>>> +       if (!is_dir || samefs || ovl_xino_bits(dentry->d_sb)) {
>>>>                 if (OVL_TYPE_ORIGIN(type)) {
>>>>                         struct kstat lowerstat;
>>>>                         u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
>>>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>>>> index 4432599ecbc6..09f5b8ce70aa 100644
>>>> --- a/fs/overlayfs/overlayfs.h
>>>> +++ b/fs/overlayfs/overlayfs.h
>>>> @@ -202,7 +202,8 @@ void ovl_drop_write(struct dentry *dentry);
>>>>  struct dentry *ovl_workdir(struct dentry *dentry);
>>>>  const struct cred *ovl_override_creds(struct super_block *sb);
>>>>  struct super_block *ovl_same_sb(struct super_block *sb);
>>>> -bool ovl_can_decode_fh(struct super_block *sb);
>>>> +int ovl_xino_bits(struct super_block *sb);
>>>> +int ovl_can_decode_fh(struct super_block *sb);
>>>>  struct dentry *ovl_indexdir(struct super_block *sb);
>>>>  bool ovl_index_all(struct super_block *sb);
>>>>  bool ovl_verify_lower(struct super_block *sb);
>>>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>>>> index e1c838c27a74..6a077fb2a75f 100644
>>>> --- a/fs/overlayfs/ovl_entry.h
>>>> +++ b/fs/overlayfs/ovl_entry.h
>>>> @@ -63,6 +63,8 @@ struct ovl_fs {
>>>>         /* Did we take the inuse lock? */
>>>>         bool upperdir_locked;
>>>>         bool workdir_locked;
>>>> +       /* Inode numbers in all layers do not use the high xino_bits */
>>>> +       int xino_bits;
>>>>  };
>>>>
>>>>  /* private information held for every overlayfs dentry */
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 7d97d30cad39..d7284444f404 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>>>> @@ -17,6 +17,7 @@
>>>>  #include <linux/statfs.h>
>>>>  #include <linux/seq_file.h>
>>>>  #include <linux/posix_acl_xattr.h>
>>>> +#include <linux/exportfs.h>
>>>>  #include "overlayfs.h"
>>>>
>>>>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>>>> @@ -701,6 +702,7 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
>>>>  static int ovl_lower_dir(const char *name, struct path *path,
>>>>                          struct ovl_fs *ofs, int *stack_depth, bool *remote)
>>>>  {
>>>> +       int fh_type;
>>>>         int err;
>>>>
>>>>         err = ovl_mount_dir_noesc(name, path);
>>>> @@ -720,15 +722,19 @@ static int ovl_lower_dir(const char *name, struct path *path,
>>>>          * The inodes index feature and NFS export need to encode and decode
>>>>          * file handles, so they require that all layers support them.
>>>>          */
>>>> +       fh_type = ovl_can_decode_fh(path->dentry->d_sb);
>>>>         if ((ofs->config.nfs_export ||
>>>> -            (ofs->config.index && ofs->config.upperdir)) &&
>>>> -           !ovl_can_decode_fh(path->dentry->d_sb)) {
>>>> +            (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
>>>>                 ofs->config.index = false;
>>>>                 ofs->config.nfs_export = false;
>>>>                 pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
>>>>                         name);
>>>>         }
>>>>
>>>> +       /* Check if lower fs has 32bit inode numbers */
>>>> +       if (fh_type != FILEID_INO32_GEN)
>>>> +               ofs->xino_bits = 0;
>>>> +
>>>>         return 0;
>>>>
>>>>  out_put:
>>>> @@ -952,6 +958,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>>>>  {
>>>>         struct vfsmount *mnt = ofs->upper_mnt;
>>>>         struct dentry *temp;
>>>> +       int fh_type;
>>>>         int err;
>>>>
>>>>         err = mnt_want_write(mnt);
>>>> @@ -1001,12 +1008,16 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>>>>         }
>>>>
>>>>         /* Check if upper/work fs supports file handles */
>>>> -       if (ofs->config.index &&
>>>> -           !ovl_can_decode_fh(ofs->workdir->d_sb)) {
>>>> +       fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
>>>> +       if (ofs->config.index && !fh_type) {
>>>>                 ofs->config.index = false;
>>>>                 pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
>>>>         }
>>>>
>>>> +       /* Check if upper fs has 32bit inode numbers */
>>>> +       if (fh_type != FILEID_INO32_GEN)
>>>> +               ofs->xino_bits = 0;
>>>> +
>>>>         /* NFS export of r/w mount depends on index */
>>>>         if (ofs->config.nfs_export && !ofs->config.index) {
>>>>                 pr_warn("overlayfs: NFS export requires \"index=on\", falling back to nfs_export=off.\n");
>>>> @@ -1185,6 +1196,11 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
>>>>                 }
>>>>                 ofs->numlower++;
>>>>         }
>>>> +
>>>> +       /* When all layers on same fs, overlay can use real inode numbers */
>>>> +       if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt))
>>>> +               ofs->xino_bits = 0;
>>>> +
>>>>         err = 0;
>>>>  out:
>>>>         return err;
>>>> @@ -1308,6 +1324,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>>>
>>>>         sb->s_stack_depth = 0;
>>>>         sb->s_maxbytes = MAX_LFS_FILESIZE;
>>>> +       /* Assume underlaying fs uses 32bit inodes unless proven otherwise */
>>>> +       ofs->xino_bits = BITS_PER_LONG - 32;
>>>
>>> This disables xino for 32bit archs.  Which is probably the right thing
>>> to do, otherwise there might be a regression in some cases since
>>> kernel will return EOVERFLOW if st_ino would overflow. Well, this is
>>> true for 32bit mode in 64bit kernel as well, so the above is not a
>>> perfect solution.
>>>
>>> Not sure if we need to worry.  For 32bit archs, I think disabling xino
>>> is OK; it can be enabled explicitly if needed.  For 64bit archs, let's
>>> hope it doesn't regress for anybody and if it does, we need to take
>>> steps.
>>
>> Perhaps, the steps would be to implement -o noxino.
>
> And that would need to be the default if selected by a kernel config
> option.   Should we do that now, to prevent surprises?  Maybe we
> should; it does't cost anything in complexity, and I think it's better
> to let the user choose between backward compatibility and new feature.
>

So you mean same as other features?

OVERLAY_FS_XINO defaults to n
and mount options xino=on/off.

Makes sense.
I can do that.

Thanks,
Amir.

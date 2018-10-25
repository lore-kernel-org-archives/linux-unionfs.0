Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181024195837.35532-1-olga.kornievskaia@gmail.com> <20181024195837.35532-2-olga.kornievskaia@gmail.com>
In-Reply-To: <20181024195837.35532-2-olga.kornievskaia@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 25 Oct 2018 07:34:31 +0300
Message-ID: <CAOQ4uxgx1YZfn2GsTQhGzxgZ4AMxMocCOrKOEo8StVVfr=2cyQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] VFS permit cross device vfs_copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 10:58 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> From: Olga Kornievskaia <kolga@netapp.com>
>
> This patch removes the check for source and destination files to
> come from the same superblock. This feature was of interest to
> NFS as well as CIFS communities.
>
> Specifically, this feature is needed to allow for NFSv4.2 copy offload
> to be done between different NFSv4.2 servers. SMBv3 copy offload between
> different servers would be able to use this as well.
>
> Removal of the check implies that passed in source and destination
> files can come from different superblocks of the same file system
> type or different. It is upto each individual copy_file_range()
> file system implementation to decide what type of copy it is
> capable of doing and return -EXDEV in cases support is lacking.
>
> There are 3 known implementator of copy_file_range() f_op: NFS,
> CIFS, OverlayFS. NFS and CIFS are interested to support cross-device
> copy offload but do not support cross file system types copy offload.
> Following patches will add appropriate checks in each of the drivers.
>

That should be the other way around - first add limitation inside filesystems
then relax vfs check. otherwise you leave a bug in the middle of bisect.

> If the copy_file_range() errors with EXDEV, the code would fallback
> on doing do_splice_direct() copying which in itself is beneficial.
>
> Adding wording to the vfs.txt and porting documentation about the
> new support for cross-device copy offload.
>
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  Documentation/filesystems/porting | 7 +++++++
>  Documentation/filesystems/vfs.txt | 6 +++++-
>  fs/read_write.c                   | 9 +++------
>  3 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
> index 7b7b845..ebb4954 100644
> --- a/Documentation/filesystems/porting
> +++ b/Documentation/filesystems/porting
> @@ -622,3 +622,10 @@ in your dentry operations instead.
>         alloc_file_clone(file, flags, ops) does not affect any caller's references.
>         On success you get a new struct file sharing the mount/dentry with the
>         original, on failure - ERR_PTR().
> +--
> +[mandatory]
> +       ->copy_file_range() may now be passed files which belong to two
> +       different superblocks of the same file system type or which belong
> +       to two different filesystems types all together. As before, the
> +        destination's copy_file_range() is the function which is called.
> +       If it cannot copy ranges from the source, it should return -EXDEV.
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index a6c6a8a..34c0e8c 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -1,5 +1,6 @@
>
>               Overview of the Linux Virtual File System
> +- [fs] nfs: Don't let readdirplus revalidate an inode that was marked as stale (Benjamin Coddington) [1429514 1416532]
>

???

Thanks,
Amir.

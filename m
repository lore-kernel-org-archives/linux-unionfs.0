From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4] overlayfs: override_creds=off option bypass creator_cred
Date: Sat, 23 Jun 2018 09:46:07 +0300
Message-ID: <CAOQ4uxiUaJHZ5coUNwH1ZYQjVB8dmAo0Y0bDKOmZM81tzCqC8g@mail.gmail.com>
References: <20180622171605.52989-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622171605.52989-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 22, 2018 at 8:16 PM, Mark Salyzyn <salyzyn@android.com> wrote:
> By default, all access to the upper, lower and work directories is the
> recorded mounter's MAC and DAC credentials.  The incoming accesses are
> checked against the caller's credentials.
>
> If the principles of least privilege are applied, the mounter's
> credentials might not overlap the credentials of the caller's when
> accessing the overlayfs filesystem.  For example, a file that a lower
> DAC privileged caller can execute, is MAC denied to the generally
> higher DAC privileged mounter, to prevent an attack vector.
>
> We add the option to turn off override_creds in the mount options; all
> subsequent operations after mount on the filesystem will be only the
> caller's credentials.  This option default is set in the CONFIG
> OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
>
> The module boolean parameter and mount option override_creds is also
> added as a presence check for this "feature" by checking existence of
> /sys/module/overlay/parameters/overlay_creds.  This will allow user
> space to determine if the option can be supplied successfully to the
> mount(2) operation.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
> v2:
> - Forward port changed attr to stat, resulting in a build error.
> - altered commit message.
>
> v3:
> - Change name from caller_credentials / creator_credentials to the
>   boolean override_creds.
> - Changed from creator to mounter credentials.
> - Updated and fortified the documentation.
> - Added CONFIG_OVERLAY_FS_OVERRIDE_CREDS
>
> v4:
> - spelling and grammar errors in text
>
>  Documentation/filesystems/overlayfs.txt | 17 +++++++++++++++++
>  fs/overlayfs/Kconfig                    | 20 ++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  2 +-
>  fs/overlayfs/dir.c                      |  9 +++++----
>  fs/overlayfs/inode.c                    | 16 ++++++++--------
>  fs/overlayfs/namei.c                    |  6 +++---
>  fs/overlayfs/overlayfs.h                |  1 +
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  4 ++--
>  fs/overlayfs/super.c                    | 21 +++++++++++++++++++++
>  fs/overlayfs/util.c                     | 12 ++++++++++--
>  11 files changed, 89 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 72615a2c0752..18e6d70ea4c9 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -106,6 +106,23 @@ Only the lists of names from directories are merged.  Other content
>  such as metadata and extended attributes are reported for the upper
>  directory only.  These attributes of the lower directory are hidden.
>
> +credentials
> +-----------
> +
> +By default, all access to the upper, lower and work directories is the
> +recorded mounter's MAC and DAC credentials.  The incoming accesses are
> +checked against the caller's credentials.
> +
> +If the principles of least privilege are applied, the mounter's
> +credentials might not overlap the credentials of the caller's when
> +accessing the overlayfs filesystem.  For example, a file that a lower
> +DAC privileged caller can execute, is MAC denied to the generally
> +higher DAC privileged mounter, to prevent an attack vector.  One
> +option is to turn off override_creds in the mount options; all
> +subsequent operations after mount on the filesystem will be only the
> +caller's credentials.  This option default is set in the CONFIG
> +OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
> +

Mark,

Thanks for the properly documented patch, but this documentation it
missing the caveats of this config option and there are severe caveats
as was discussed on earlier version of the patch.

You should mention the not so minor detail that this option can result
in inability to delete files/directories from overlay and there me be other
side effects. This is one of those features that should be warning
unconditionally that user should really know what user is doing.

You did not address my concern that the test for setting trusted xattr
on mount (ovl_make_workdir) should emit a different kind of warning
when override_creds=off. In fact, I think it should emit a warning
when override_creds=off unconditionally to indicate that weird things
can be expected and we "really hope you know what you are doing".

A new security concern I just noticed - overlayfs calls some vfs
functions directly to perform operations that are typically not
allowed to unprivileged users without checking credentials.
In those cases your patch introduces a security vulnerability.

Examples:
- overlayfs calls exportfs_decode_fh() on underlying
fs without checking CAP_DAC_READ_SEARCH
- overlayfs calls vfs_whiteout() which calls underlying fs mknod
without checking CAP_MKNOD

Those examples could be easily fixed and you may righfully
claim that they are bugs, but the fact is that those "bugs" are
harmless until someone creates an irregular security model
without capabilities to mount, without capability to mknod.

What's worse is that you have to audit the overlayfs code and
find all these potential bugs and fix them before changing the
assumptions that were made over the years about mounter
credentials.

Thanks,
Amir.

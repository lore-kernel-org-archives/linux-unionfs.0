From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 3/3] overlayfs: override_creds=off option bypass creator_cred
Date: Wed, 29 Aug 2018 00:32:49 +0300
Message-ID: <CAOQ4uxihQvnMAJUCW2n6DgkVmKP3o84neL+5r4zM-35HKxxc9w@mail.gmail.com>
References: <20180828165336.211643-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828165336.211643-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Aug 28, 2018 at 7:53 PM Mark Salyzyn <salyzyn@android.com> wrote:
>
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
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
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
> v5:
> - beefed up the caveats in the Documentation
> - Is dependent on
>   "overlayfs: check CAP_DAC_READ_SEARCH before issuing exportfs_decode_fh"
>   "overlayfs: check CAP_MKNOD before issuing vfs_whiteout"
> - Added prwarn when override_creds=off
> ---
>  Documentation/filesystems/overlayfs.txt | 29 +++++++++++++++++++++++++
>  fs/overlayfs/Kconfig                    | 22 +++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  2 +-
>  fs/overlayfs/dir.c                      |  9 ++++----
>  fs/overlayfs/inode.c                    | 16 +++++++-------
>  fs/overlayfs/namei.c                    |  6 ++---
>  fs/overlayfs/overlayfs.h                |  1 +
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  4 ++--
>  fs/overlayfs/super.c                    | 23 ++++++++++++++++++++
>  fs/overlayfs/util.c                     | 12 ++++++++--
>  11 files changed, 105 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 72615a2c0752..953e52971eb0 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -106,6 +106,35 @@ Only the lists of names from directories are merged.  Other content
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
> +DAC privileged caller can execute, but is MAC denied to the
> +generally higher DAC privileged mounter, to prevent an attack vector
> +executing with the increased privileges of the mounter.  One option is
> +to turn off override_creds in the mount options; all subsequent
> +operations after mount on the filesystem will be only the caller's
> +credentials.  This option default is set in the CONFIG
> +OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
> +Fundamentally The mounter has privileges, its ability to execute,
> +for example, files and grant them these higher privileges is to be
> +blocked except to lower privileged and appropriate callers.  This
> +option turned off permits this kind of security policy.
> +
> +With override_creds turned off, several unintended side effects will
> +occur.  The caller with a lower privilege will not be able to delete
> +files or directories, create nodes, or search some directories.  The
> +uneven security model where upperdir and workdir are opened at
> +privilege, but accessed without, should only be used with strict
> +understanding of the side effects and of the security policies.
> +
>  whiteouts and opaque directories
>  --------------------------------
>
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 9384164253ac..b55bb0d48415 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -103,3 +103,25 @@ config OVERLAY_FS_XINO_AUTO
>           For more information, see Documentation/filesystems/overlayfs.txt
>
>           If unsure, say N.
> +
> +config OVERLAY_FS_OVERRIDE_CREDS
> +       bool "Overlay filesystem override credentials"
> +       depends on OVERLAY_FS
> +       default y
> +       help
> +         If set, all access to the upper, lower and work directories is the
> +         recorded mounter's MAC and DAC credentials.  The incoming accesses
> +         are checked against the caller's credentials.
> +
> +         If the principles of least privilege are applied, the mounter's
> +         credentials might not overlap the credentials of the caller's when
> +         accessing the overlayfs filesystem.  The mount option
> +         "override_creds=off" drops the mounter's credential check, so that
> +         all subsequent operations, after mount, on the filesystem will only
> +         be the caller's credentials.  This option sets the default for the
> +         module option override_creds, and thus the default for all mounts
> +         that do not specify this option.
> +

Was it me that suggested a config option??
because I can't thing of a reason to configure this as the default.
...

>
>         sb->s_root = root_dentry;
> +       if (!ofs->config.override_creds)
> +               pr_warn("overlayfs: override_creds=off, uneven security model where mounter privileges do not overlap caller.\n");
>

This is not what the user needs to be warned about IMO.
User should be warned about consequences.

Thanks,
Amir.

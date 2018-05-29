From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 03/28] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Tue, 29 May 2018 13:44:04 -0700
Message-ID: <d5621dfa-46f6-4b5a-4d69-6c6fb9370cfe@infradead.org>
References: <20180529144612.16675-1-mszeredi@redhat.com>
 <20180529144612.16675-4-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-4-mszeredi@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 05/29/2018 07:45 AM, Miklos Szeredi wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> 
> By default metadata only copy up is disabled.  Provide a mount option so
> that users can choose one way or other.
> 
> Also provide a kernel config and module option to enable/disable metacopy
> feature.
> 
> metacopy feature requires redirect_dir=on when upper is present.
> Otherwise, it requires redirect_dir=follow atleast.
> 
> As of now, metacopy does not work with nfs_export=on.  So if both
> metacopy=on and nfs_export=on then nfs_export is disabled.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  Documentation/filesystems/overlayfs.txt | 30 ++++++++++++++++++++-
>  fs/overlayfs/Kconfig                    | 19 ++++++++++++++
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/super.c                    | 46 ++++++++++++++++++++++++++++++---
>  4 files changed, 92 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index f087bc40c6a5..79be4a77ca08 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -262,6 +262,30 @@ rightmost one and going left.  In the above example lower1 will be the
>  top, lower2 the middle and lower3 the bottom layer.
>  
>  
> +Metadata only copy up
> +--------------------
> +
> +When metadata only copy up feature is enabled, overlayfs will only copy
> +up metadata (as opposed to whole file), when a metadata specific operation
> +like chown/chmod is performed. Full file will be copied up later when
> +file is opened for WRITE operation.
> +
> +In other words, this is delayed data copy up operation and data is copied
> +up when there is a need to actually modify data.
> +
> +There are multiple ways to enable/disable this feature. A config option
> +CONFIG_OVERLAY_FS_METACOPY can be set/unset to enable/disable this feature
> +by default. Or one can enable/disable it at module load time with module
> +parameter metacopy=on/off. Lastly, there is also a per mount option
> +metacopy=on/off to enable/disable this feature per mount.
> +
> +Do not use metacopy=on with untrusted upper/lower directories. Otherwise
> +it is possible that an attacker can create an handcrafted file with

                                              a handcrafted

> +appropriate REDIRECT and METACOPY xattrs, and gain access to file on lower
> +pointed by REDIRECT. This should not be possible on local system as setting
> +"trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
> +for untrusted layers like from a pen drive.
> +
>  Sharing and copying layers
>  --------------------------
>  
> @@ -280,7 +304,7 @@ though it will not result in a crash or deadlock.
>  Mounting an overlay using an upper layer path, where the upper layer path
>  was previously used by another mounted overlay in combination with a
>  different lower layer path, is allowed, unless the "inodes index" feature
> -is enabled.
> +or "metadata only copy up" feature is enabled.
>  
>  With the "inodes index" feature, on the first time mount, an NFS file
>  handle of the lower layer root directory, along with the UUID of the lower
> @@ -293,6 +317,10 @@ lower root origin, mount will fail with ESTALE.  An overlayfs mount with
>  does not support NFS export, lower filesystem does not have a valid UUID or
>  if the upper filesystem does not support extended attributes.
>  
> +For "metadata only copy up" feature there is no verification mechanism at
> +mount time. So if same upper is mouted with different set of lower, mount

                                   mounted

> +probably will succeed but expect the unexpected later on. So don't do it.
> +
>  It is quite a common practice to copy overlay layers to a different
>  directory tree on the same or different underlying filesystem, and even
>  to a different machine.  With the "inodes index" feature, trying to mount
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 5d1d40d745c5..e0a090eca65e 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -64,6 +64,7 @@ config OVERLAY_FS_NFS_EXPORT
>  	bool "Overlayfs: turn on NFS export feature by default"
>  	depends on OVERLAY_FS
>  	depends on OVERLAY_FS_INDEX
> +	depends on !OVERLAY_FS_METACOPY
>  	help
>  	  If this config option is enabled then overlay filesystems will use
>  	  the inodes index dir to decode overlay NFS file handles by default.

	  Is that ... dir  ^^^ == directory ?  Please spell it out.

> @@ -124,3 +125,21 @@ config OVERLAY_FS_COPY_UP_SHARED
>  	  To get a maximally backward compatible kernel, disable this option.
>  
>  	  If unsure, say N.
> +
> +config OVERLAY_FS_METACOPY
> +	bool "Overlayfs: turn on metadata only copy up feature by default"
> +	depends on OVERLAY_FS
> +	select OVERLAY_FS_REDIRECT_DIR
> +	help
> +	  If this config option is enabled then overlay filesystems will
> +	  copy up only metadata where appropriate and data copy up will
> +	  happen when a file is opended for WRITE operation. It is still

	                        opened

> +	  possible to turn off this feature globally with the "metacopy=off"
> +	  module option or on a filesystem instance basis with the
> +	  "metacopy=off" mount option.
> +
> +	  Note, that this feature is not backward compatible.  That is,
> +	  mounting an overlay which has metacopy only inodes on a kernel
> +	  that doesn't support this feature will have unexpected results.
> +
> +	  If unsure, say N.


-- 
~Randy

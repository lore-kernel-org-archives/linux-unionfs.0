From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3] overlayfs: override_creds=off option bypass
 creator_cred
Date: Fri, 22 Jun 2018 08:56:29 -0700
Message-ID: <56cd58e0-c61f-6580-d388-b0146108fed7@infradead.org>
References: <20180622152056.16877-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622152056.16877-1-salyzyn@android.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>, linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@android.com
List-Id: linux-unionfs@vger.kernel.org

Hi Mark,

On 06/22/2018 08:20 AM, Mark Salyzyn wrote:
> By default, all access to the upper, lower and work directories is the
> recorded mounter's MAC and DAC credentials.  The incoming accesses are
> checked against the caller's credentials.
> 
> If the principals of least privilege are applied, the mounter's

         principles

> credentials might not overlap the credential of the caller's when
> accessing the overlayfs filesystem.  For example, a file that a lower
> DAC privileged caller can execute, is MAC denied to the generally
> higher DAC privileged mounter, to prevent an attack vector.
> 
> We add the option to turn off override_creds in the mount options, all
> subsequent operations after mount on the filesystem will be only the
> caller's credentials.  This option default is set in the CONFIG
> OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
> 
> The module bool parameter and mount option override_creds is also

             boolean

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
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@android.com
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
>  Documentation/filesystems/overlayfs.txt | 17 +++++++++++++++++
>  fs/overlayfs/Kconfig                    | 21 +++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  2 +-
>  fs/overlayfs/dir.c                      |  9 +++++----
>  fs/overlayfs/inode.c                    | 16 ++++++++--------
>  fs/overlayfs/namei.c                    |  6 +++---
>  fs/overlayfs/overlayfs.h                |  1 +
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  4 ++--
>  fs/overlayfs/super.c                    | 21 +++++++++++++++++++++
>  fs/overlayfs/util.c                     | 12 ++++++++++--
>  11 files changed, 90 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 72615a2c0752..5c646f993a4b 100644
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
> +If the principals of least privilege are applied, the mounter's

          principles

> +credentials might not overlap the credential of the caller's when

                                     credentials (?)

> +accessing the overlayfs filesystem.  For example, a file that a lower
> +DAC privileged caller can execute, is MAC denied to the generally
> +higher DAC privileged mounter, to prevent an attack vector.  One
> +option is to turn off override_creds in the mount options, all

                                                     options; all

> +subsequent operations after mount on the filesystem will be only the
> +caller's credentials.  This option default is set in the CONFIG
> +OVERLAY_FS_OVERRIDE_CREDS or in the module option override_creds.
> +
>  whiteouts and opaque directories
>  --------------------------------
>  
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 9384164253ac..1ecb910f0300 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -103,3 +103,24 @@ config OVERLAY_FS_XINO_AUTO
>  	  For more information, see Documentation/filesystems/overlayfs.txt
>  
>  	  If unsure, say N.
> +
> +config OVERLAY_FS_OVERRIDE_CREDS
> +	bool "Overlay filesystem override credentials"
> +	depends on OVERLAY_FS
> +	default y
> +	help
> +	  If set, all access to the upper, lower and work directories is the
> +	  recorded mounter's MAC and DAC credentials.  The incoming accesses are
> +	  checked against the caller's credentials.  The check of both access
> +	  credentials.

	  last "sentence" is incomplete.

> +
> +	  If the principals of least privilege are applied, the mounter's

	         principles

> +	  credentials might not overlap the credential of the caller's when
> +	  accessing the overlayfs filesystem.  The mount option override_creds=n

	                                                        "override_creds=n"

> +	  drops the mounter's credential check, so that all subsequent
> +	  operations, after mount, on the filesystem will only be the
> +	  caller's credentials.  This option sets the default for the module
> +	  option override_creds, and thus the default for all mounts that
> +	  do not specify this option.
> +
> +	  For more information see Documentation/filesystems/overlayfs.txt


-- 
~Randy

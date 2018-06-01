From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [GIT PULL] overlayfs update for 4.18
Date: Fri, 1 Jun 2018 09:18:02 -0700
Message-ID: <1d1b5ffb-4786-6b7a-fbf3-84b79080ccff@infradead.org>
References: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
 <20180601152625.GD23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601152625.GD23785@veci.piliscsaba.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/01/2018 08:26 AM, Miklos Szeredi wrote:
> On Tue, May 29, 2018 at 03:21:48PM +0200, Miklos Szeredi wrote:
>> Hi Al,
>>
>> I'm sending this pull request to you instead of Linus, because a bigger than
>> usual chunk involves the VFS.
>>
>> Please pull from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro
>>
>> This update contains the following:


> ---
> 
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 0a8e3c4543d1..79be4a77ca08 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -280,7 +280,7 @@ parameter metacopy=on/off. Lastly, there is also a per mount option
>  metacopy=on/off to enable/disable this feature per mount.
>  
>  Do not use metacopy=on with untrusted upper/lower directories. Otherwise
> -it is possible that an attacker can create a handcrafted file with
> +it is possible that an attacker can create an handcrafted file with

bad change:
                                       create a handcrafted

Wait. Is this patch -R (reversed)?

>  appropriate REDIRECT and METACOPY xattrs, and gain access to file on lower
>  pointed by REDIRECT. This should not be possible on local system as setting
>  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
> @@ -318,7 +318,7 @@ does not support NFS export, lower filesystem does not have a valid UUID or
>  if the upper filesystem does not support extended attributes.
>  
>  For "metadata only copy up" feature there is no verification mechanism at
> -mount time. So if same upper is mounted with different set of lower, mount
> +mount time. So if same upper is mouted with different set of lower, mount

                                   mounted

>  probably will succeed but expect the unexpected later on. So don't do it.
>  
>  It is quite a common practice to copy overlay layers to a different
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 08b04d9fd6e6..e0a090eca65e 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -11,7 +11,7 @@ config OVERLAY_FS
>  	  For more information see Documentation/filesystems/overlayfs.txt
>  
>  config OVERLAY_FS_REDIRECT_DIR
> -	bool "Overlayfs: turn on redirect directory feature by default"
> +	bool "Overlayfs: turn on redirect dir feature by default"

nope.

>  	depends on OVERLAY_FS
>  	help
>  	  If this config option is enabled then overlay filesystems will use
> @@ -46,7 +46,7 @@ config OVERLAY_FS_INDEX
>  	depends on OVERLAY_FS
>  	help
>  	  If this config option is enabled then overlay filesystems will use
> -	  the index directory to map lower inodes to upper inodes by default.
> +	  the inodes index dir to map lower inodes to upper inodes by default.
>  	  In this case it is still possible to turn off index globally with the
>  	  "index=off" module option or on a filesystem instance basis with the
>  	  "index=off" mount option.
> @@ -67,7 +67,7 @@ config OVERLAY_FS_NFS_EXPORT
>  	depends on !OVERLAY_FS_METACOPY
>  	help
>  	  If this config option is enabled then overlay filesystems will use
> -	  the index directory to decode overlay NFS file handles by default.
> +	  the inodes index dir to decode overlay NFS file handles by default.
>  	  In this case, it is still possible to turn off NFS export support
>  	  globally with the "nfs_export=off" module option or on a filesystem
>  	  instance basis with the "nfs_export=off" mount option.
> @@ -133,7 +133,7 @@ config OVERLAY_FS_METACOPY
>  	help
>  	  If this config option is enabled then overlay filesystems will
>  	  copy up only metadata where appropriate and data copy up will
> -	  happen when a file is opened for WRITE operation. It is still
> +	  happen when a file is opended for WRITE operation. It is still

nope.

>  	  possible to turn off this feature globally with the "metacopy=off"
>  	  module option or on a filesystem instance basis with the
>  	  "metacopy=off" mount option.


-- 
~Randy

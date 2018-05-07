From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 23/35] ovl: copy-up on MAP_SHARED
Date: Mon, 7 May 2018 12:28:34 -0700
Message-ID: <8f464b5f-a479-6bfe-3abf-b2ed6efe5eb6@infradead.org>
References: <20180507083807.28792-1-mszeredi@redhat.com>
 <20180507083807.28792-24-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-24-mszeredi@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 05/07/2018 01:37 AM, Miklos Szeredi wrote:
> A corner case of a corner case is when
> 
>  - file opened for O_RDONLY
>  - which is then memory mapped SHARED
>  - file opened for O_WRONLY
>  - contents modified
>  - contents read back though the shared mapping
> 
> Unfortunately it looks very difficult to do anything about the established
> shared map after the file is copied up.
> 
> Instead, when a read-only file is mapped shared, copy up the file before
> actually doing the map.  This may result in unnecessary copy-ups (but so
> may copy-up on open(O_RDWR) for exampe).

                              for example).

> 
> We can revisit this later if it turns out to be a performance problem in
> real life.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/Kconfig     | 21 +++++++++++++++++++++
>  fs/overlayfs/file.c      | 22 ++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  7 +++++++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 22 ++++++++++++++++++++++
>  5 files changed, 73 insertions(+)
> 
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 17032631c5cf..991c0a5a0e00 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -103,3 +103,24 @@ config OVERLAY_FS_XINO_AUTO
>  	  For more information, see Documentation/filesystems/overlayfs.txt
>  
>  	  If unsure, say N.
> +
> +config OVERLAY_FS_COPY_UP_SHARED
> +       bool "Overlayfs: copy up when mapping a file shared"

	                                        a shared file" ??

> +       default n
> +       depends on OVERLAY_FS
> +       help
> +         If this option is enabled then on mapping a file with MAP_SHARED
> +	 overlayfs copies up the file in anticipation of it being modified (just
> +	 like we copy up the file on O_WRONLY and O_RDWR in anticipation of
> +	 modification).  This does not interfere with shared library loading, as
> +	 that uses MAP_PRIVATE.  But there might be use cases out there where
> +	 this impacts performance and disk usage.
> +
> +	 This just selects the default, the feature can also be enabled or
> +	 disabled in the running kernel or individually on each overlay mount.
> +
> +	 To get maximally standard compliant behavior, enable this option.
> +
> +	 To get a maximally backward compatible kernel, disable this option.
> +
> +	 If unsure, say N.

For Kconfig (coding-style.rst):
Lines under a ``config`` definition are indented with one tab, while help text
is indented an additional two spaces.


-- 
~Randy

Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Thu, 29 Mar 2018 11:21:03 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/3] open_by_handle: add -n option to suppress drop caches
Message-ID: <20180329032103.GH30836@localhost.localdomain>
References: <1521989591-9496-1-git-send-email-amir73il@gmail.com>
 <1521989591-9496-2-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521989591-9496-2-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Mar 25, 2018 at 05:53:09PM +0300, Amir Goldstein wrote:
> By default, open_by_handle drops inode and page caches before trying
> to open by file handles. Add an option to suppress drop caches for
> testing open by handle with warm caches.
> 
> Usage: open_by_handle -n <test_dir> [N]
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  src/open_by_handle.c | 41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/src/open_by_handle.c b/src/open_by_handle.c
> index 78f7ef7..d3beb78 100644
> --- a/src/open_by_handle.c
> +++ b/src/open_by_handle.c
> @@ -27,7 +27,7 @@
>  
>  /*
>  
> -usage: open_by_handle [-cludmrwapk] [<-i|-o> <handles_file>] <test_dir> [num_files]
> +usage: open_by_handle [-cludmrwapknh] [<-i|-o> <handles_file>] <test_dir> [num_files]

Better to mention that it fixes the 'h' option too in the commit log, or
maybe just send a separate patch?

Otherwise looks fine to me.

Thanks,
Eryu

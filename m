From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] fstests: add helper _require_exportfs
Date: Wed, 19 Apr 2017 17:44:29 +0800
Message-ID: <20170419094429.GP8951@eguan.usersys.redhat.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-4-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1492539444-25938-4-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 09:17:23PM +0300, Amir Goldstein wrote:
> Use open_by_handle -c to determine if filesystem supports NFS export
> ---
>  common/rc | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 685b859..f24a21f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2857,6 +2857,15 @@ _require_freeze()
>  	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
>  }
>  
> +# Does NFS export work on this fs?
> +_require_exportfs()
> +{
> +	mkdir -p "$TEST_DIR"/export_test
> +	$here/src/open_by_handle -c "$TEST_DIR"/export_test 2>&1 \
> +		|| _notrun "$FSTYP does not support NFS export"

_require_test_program "open_by_handle" first?

Thanks,
Eryu

> +}
> +
> +
>  # Does shutdown work on this fs?
>  _require_scratch_shutdown()
>  {
> -- 
> 2.7.4
> 

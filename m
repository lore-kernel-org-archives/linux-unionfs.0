From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] ovl: create UUIDs for file systems that do not set the
 superblock UUID
Date: Thu, 7 Nov 2019 10:18:43 +0300
Message-ID: <20191107071843.GN10409@kadam>
References: <20191106234301.283006-1-colin.king@canonical.com>
 <CAOQ4uxhT4pFzHjjKyoMOc3xVXXqyqc37zd=-pCx2+keA4e6NAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhT4pFzHjjKyoMOc3xVXXqyqc37zd=-pCx2+keA4e6NAg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Colin King <colin.king@canonical.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 07, 2019 at 09:08:44AM +0200, Amir Goldstein wrote:
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index a8279280e88d..a0227c31fe17 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -22,6 +22,8 @@ struct ovl_config {
>  struct ovl_sb {
>  	struct super_block *sb;
>  	dev_t pseudo_dev;
> +	/* Unusable (conflicting) uuid */
> +	bool nouuid;

Could we name this ignore_uuid, skip_uuid or bad_uuid or something?
Otherwise we end up with double negatives.

regards,
dan carpenter

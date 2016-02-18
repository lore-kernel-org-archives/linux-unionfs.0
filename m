From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH] ovl: fix working on distributed fs as lower layer
Date: Thu, 18 Feb 2016 09:56:24 +0200
Message-ID: <56C57928.2010606@kyup.com>
References: <145424653619.10827.10119853770850679426.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35544 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542AbcBRH42 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Feb 2016 02:56:28 -0500
Received: by mail-wm0-f50.google.com with SMTP id c200so13335860wme.0
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Feb 2016 23:56:26 -0800 (PST)
In-Reply-To: <145424653619.10827.10119853770850679426.stgit@zurg>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>



On 01/31/2016 03:22 PM, Konstantin Khlebnikov wrote:
> This adds missing .d_select_inode into alternative dentry_operations.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Fixes: 7c03b5d45b8e ("ovl: allow distributed fs as lower layer")
> Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
> ---
>  fs/overlayfs/super.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e6ae59c7119c..1a354840f262 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -343,6 +343,7 @@ static const struct dentry_operations ovl_dentry_operations = {
>  
>  static const struct dentry_operations ovl_reval_dentry_operations = {
>  	.d_release = ovl_dentry_release,
> +	.d_select_inode = ovl_d_select_inode,
>  	.d_revalidate = ovl_dentry_revalidate,
>  	.d_weak_revalidate = ovl_dentry_weak_revalidate,
>  };

I wish I had seen this patch earlier than
https://marc.info/?l=linux-unionfs&m=145494313009959


Reviewed-by: Nikolay Borisov <kernel@kyup.com>
Tested-by: Nikolay Borisov <kernel@kyup.com>

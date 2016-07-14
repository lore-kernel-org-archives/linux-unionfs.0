From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH -next] ovl: remove duplicated include from super.c
Date: Thu, 14 Jul 2016 10:59:03 +0200
Message-ID: <CAJfpeguT_xWbQVdOVRCd53dE9u8C9s_nEmWw_=kf-_MdXDMKmw@mail.gmail.com>
References: <1467808035-32411-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36318 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbcGNI7E (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 04:59:04 -0400
Received: by mail-oi0-f66.google.com with SMTP id u68so6301736oie.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 01:59:04 -0700 (PDT)
In-Reply-To: <1467808035-32411-1-git-send-email-weiyj_lk@163.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: weiyj_lk@163.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jul 6, 2016 at 2:27 PM,  <weiyj_lk@163.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove duplicated include.

Queued.  Thanks.

Miklos

>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/overlayfs/super.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e1f5203..f931490 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -16,7 +16,6 @@
>  #include <linux/slab.h>
>  #include <linux/parser.h>
>  #include <linux/module.h>
> -#include <linux/pagemap.h>
>  #include <linux/sched.h>
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
>
>
>
>

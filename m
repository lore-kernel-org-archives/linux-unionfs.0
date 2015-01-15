From: hujianyang <hujianyang@huawei.com>
Subject: Re: [PATCH 1/3] ovl: print error message for invalid mount options
Date: Thu, 15 Jan 2015 13:52:31 +0800
Message-ID: <54B7559F.7020900@huawei.com>
References: <54B74D70.3000205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:27112 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbbAOFwq (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 15 Jan 2015 00:52:46 -0500
In-Reply-To: <54B74D70.3000205@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Seunghun Lee <waydi1@gmail.com>, Fabian Sturm <fabian.sturm@aduu.de>

On 2015/1/15 13:17, hujianyang wrote:
> Overlayfs should print an error message if an incorrect mount option
> is caught like other filesystems.
> 
> After this patch, improper option input could be clearly known.
> 
> Reported-by: Fabian Sturm <fabian.sturm@aduu.de>
> Signed-off-by: hujianyang <hujianyang@huawei.com>
> ---
>  fs/overlayfs/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index b90952f..ab3c8cb 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -615,6 +615,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			break;
> 
>  		default:
> +			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);

Hi Miklos,

I'm sorry. The parameter "p" should begin with a new line.

I'd like to resend a new patch after you review these patches.

Thanks,
Hu

>  			return -EINVAL;
>  		}
>  	}
> 



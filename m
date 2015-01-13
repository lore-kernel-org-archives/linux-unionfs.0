From: Fabian Sturm <fabian.sturm@aduu.de>
Subject: Re: PROBLEM: Mounting multiple lowerdirs with "lowerdir=/tmp/a0,/tmp/a" returns 32
Date: Tue, 13 Jan 2015 09:27:12 +0100
Message-ID: <1788886.tOeEvUmMxs@debian-desktop-mine>
References: <3603873.tCNzyKeON0@debian-desktop-mine> <54B48055.8070806@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx01.mykolab.com ([95.128.36.1]:47980 "EHLO mx03.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbAMI17 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 13 Jan 2015 03:27:59 -0500
In-Reply-To: <54B48055.8070806@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org

Am Dienstag, 13. Januar 2015, 10:17:57 schrieben Sie:
> Hi Fabian,
> 
> Thanks for reporting.
> 
> On 2015/1/13 5:59, Fabian Sturm wrote:
> > sudo mount -t overlay -o lowerdir=/tmp/a,/tmp/a0 overlay /tmp/merged
> 
> I think the cause of this failure is the wrong mount option you
> are using.
> 
> should be:
> 
> sudo mount -t overlay -o lowerdir=/tmp/a:/tmp/a0 overlay /tmp/merged
> 
> Comma is used to separate different mount options. Overlayfs use
> colon as the separator between lower directories.
> 
> I don't know if it is a correct resolution for your problem. You
> can try it first. It's OK in my environment to mount ovl with
> numbers in directory name.
> 
> > ret=$(echo $?)
> > echo $ret
> > if [[ "$ret" == "0" ]]; then
> > 
> >     sudo umount /tmp/merged
> > 
> > fi
> > 
> > sudo mount -t overlay -o lowerdir=/tmp/a,/tmp/0a overlay /tmp/merged
> > ret=$(echo $?)
> > echo $ret
> > if [[ "$ret" == "0" ]]; then
> > 
> >     sudo umount /tmp/merged
> > 
> > fi
> 
> Anyway, I think overlayfs should print an error message if an
> incorrect mount option is caught like other filesystems.
> 
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
> @@ -615,6 +615,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config
> *config) break;
> 
>  		default:
> +			pr_err("overlayfs: unrecognized mount option \"%s\" or missing 
value\n",
> p); return -EINVAL;
>  		}
>  	}

Hello hujianyang,

I might have had not enough sleep at the time. Thanks for adding the output to 
dmesg, works fine!

Thanks,
Fabian

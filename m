From: Linzhe Lee <slayercat.subscription@gmail.com>
Subject: Re: Question about overlayfs over fs not support dirent::ftype
Date: Sun, 13 Dec 2015 12:51:56 +0800
Message-ID: <CAK_yBkOBxXaW6Z1VHV-UFjA-zS4Jor-8eu0qxAm=mYsYrgbweg@mail.gmail.com>
References: <CAK_yBkOjkk_70-EvZs_TcRh9Rb7S9jwPQ=AAREHEQToZ+o5sSA@mail.gmail.com>
	<20151210065832.GA4732@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36521 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbLMEv5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 12 Dec 2015 23:51:57 -0500
Received: by qkht125 with SMTP id t125so94191155qkh.3
        for <linux-unionfs@vger.kernel.org>; Sat, 12 Dec 2015 20:51:56 -0800 (PST)
In-Reply-To: <20151210065832.GA4732@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

This patch worked. sorry for previous false alert.

2015-12-10 14:58 GMT+08:00 Miklos Szeredi <miklos@szeredi.hu>:
> On Wed, Dec 09, 2015 at 12:42:50PM +0800, Linzhe Lee wrote:
>> Hi,all
>>
>> I got problem in using overlayfs over fs not support
>> dirent::ftype[such as xfs(-n ftype=0)]. After some dig I realized in
>> such situation, function ovl_fill_merge parameter d_type will always
>> be DT_UNKNOWN.
>>
>> I think a warning is needed of course. But because dirent::d_type is
>> not widely supported for now. I thought If we can find a way to
>> fallback to stat() call in such a situation.  How do you think this
>> idea?
>>
>> And, can you suggest a method to do it? I tried these method for now,
>> but none work.
>>
>>     1) Direct get struct inode* from inode::i_ino,  Stuck at not found
>> a proper abstract function to do it.
>>     2) Get to known fs do not support dirent::d_type and workaround.
>> Stuck at not found how to know if fs do not support dirent::d_type
>>     3) In function ctx.actor [ovl_fill_merge], use function
>> lookup_one_len to get file dirent. Stuck at lock.
>>
>> Any thought is helpful. Thank you !
>
> How about the patch below?
>
> Does that fix the issue?
>
> Thanks,
> Miklos
>
>
> ---
>  fs/overlayfs/readdir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -98,7 +98,7 @@ static struct ovl_cache_entry *ovl_cache
>         p->ino = ino;
>         p->is_whiteout = false;
>
> -       if (d_type == DT_CHR) {
> +       if (d_type == DT_CHR || d_type == DT_UNKNOWN) {
>                 p->next_maybe_whiteout = rdd->first_maybe_whiteout;
>                 rdd->first_maybe_whiteout = p;
>         }

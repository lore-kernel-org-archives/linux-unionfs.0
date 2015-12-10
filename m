From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Question about overlayfs over fs not support dirent::ftype
Date: Thu, 10 Dec 2015 07:58:32 +0100
Message-ID: <20151210065832.GA4732@tucsk>
References: <CAK_yBkOjkk_70-EvZs_TcRh9Rb7S9jwPQ=AAREHEQToZ+o5sSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33706 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbbLJG4K (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Dec 2015 01:56:10 -0500
Received: by lfaz4 with SMTP id z4so50211503lfa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Dec 2015 22:56:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAK_yBkOjkk_70-EvZs_TcRh9Rb7S9jwPQ=AAREHEQToZ+o5sSA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linzhe Lee <slayercat.subscription@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Wed, Dec 09, 2015 at 12:42:50PM +0800, Linzhe Lee wrote:
> Hi,all
> 
> I got problem in using overlayfs over fs not support
> dirent::ftype[such as xfs(-n ftype=0)]. After some dig I realized in
> such situation, function ovl_fill_merge parameter d_type will always
> be DT_UNKNOWN.
> 
> I think a warning is needed of course. But because dirent::d_type is
> not widely supported for now. I thought If we can find a way to
> fallback to stat() call in such a situation.  How do you think this
> idea?
> 
> And, can you suggest a method to do it? I tried these method for now,
> but none work.
> 
>     1) Direct get struct inode* from inode::i_ino,  Stuck at not found
> a proper abstract function to do it.
>     2) Get to known fs do not support dirent::d_type and workaround.
> Stuck at not found how to know if fs do not support dirent::d_type
>     3) In function ctx.actor [ovl_fill_merge], use function
> lookup_one_len to get file dirent. Stuck at lock.
> 
> Any thought is helpful. Thank you !

How about the patch below?

Does that fix the issue?

Thanks,
Miklos


---
 fs/overlayfs/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -98,7 +98,7 @@ static struct ovl_cache_entry *ovl_cache
 	p->ino = ino;
 	p->is_whiteout = false;
 
-	if (d_type == DT_CHR) {
+	if (d_type == DT_CHR || d_type == DT_UNKNOWN) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
 		rdd->first_maybe_whiteout = p;
 	}

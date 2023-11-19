Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3CDC072A2
	for <linux-unionfs@archiver.kernel.org>; Sun, 19 Nov 2023 07:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjKSH1B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 19 Nov 2023 02:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjKSH1B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Nov 2023 02:27:01 -0500
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A956C0;
        Sat, 18 Nov 2023 23:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=qRPxow4Lin+yP6p/mxJL+iQeukHr6XnYHzoDv2UvIm0=; b=ITaB51msH99gvORJbc7gSiA60v
        wCHPPZweYyt2URrh+hVEQs46TgJaGpbb3Pj6PEPjY5mRU9H0CYp8b+unFuydOECRJM7lpt0vuuA0l
        7+2hOM8P//19WS5Eo73Bcl4+uYuWA5bmKuSXKqVTQGgTlWPaeuqzKYjeM9nb6isQr5HHtNZJUo1Qa
        Epu/lg7lFvBaV7f6xUcdMOnTxfN/u4keTFiLXqITQITCeRW3pr5MQ3NTYagi9N7aYSHPtSIIdZ9tb
        Rh7mWHuGeGsSEtfrZ2zvYLyXJ0umxvyJyUFTpu9PUO11hXYR2KtxdckqAgcV0iDxq7HPSSokobQzM
        nJaiEZWg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r4cCi-000AMW-2N;
        Sun, 19 Nov 2023 07:26:52 +0000
Date:   Sun, 19 Nov 2023 07:26:52 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][overlayfs] do we still need d_instantiate_anon() and
 export of d_alloc_anon()?
Message-ID: <20231119072652.GA38156@ZenIV>
References: <20231111080400.GO1957730@ZenIV>
 <CAOQ4uxhQdHsegbwdqy_04eHVG+wkntA2g2qwt9wH8hb=-PtT2A@mail.gmail.com>
 <20231111185034.GP1957730@ZenIV>
 <CAOQ4uxjYaHk6rWUgvsFA4403Uk-hBqjGegV4CCOHZyh2LSYf4w@mail.gmail.com>
 <CAOQ4uxiJSum4a2F5FEA=a8JKwWh1XhFOpWaH8xas_uWKf+29cw@mail.gmail.com>
 <20231118200247.GF1957730@ZenIV>
 <CAOQ4uxjFrdKS3_yyeAcfemL-8dXm3JDWLwAmD9w3bY90=xfCjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjFrdKS3_yyeAcfemL-8dXm3JDWLwAmD9w3bY90=xfCjw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 19, 2023 at 08:57:25AM +0200, Amir Goldstein wrote:
> On Sat, Nov 18, 2023 at 10:02 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Sun, Nov 12, 2023 at 09:26:28AM +0200, Amir Goldstein wrote:
> >
> > > Tested the patch below.
> > > If you want to apply it as part of dcache cleanup, it's fine by me.
> > > Otherwise, I will queue it for the next overlayfs update.
> >
> > OK...  Let's do it that way - overlayfs part goes into never-rebased branch
> > (no matter which tree), pulled into dcache series and into your overlayfs
> > update, with removal of unused stuff done in a separate patch in dcache
> > series.
> >
> 
> Sounds good.
> 
> > That way we won't step on each other's toes when reordering, etc.
> > Does that work for you?  I can put the overlayfs part into #no-rebase-overlayfs
> > in vfs.git, or you could do it in a v6.7-rc1-based branch in your tree -
> > whatever's more convenient for you.
> 
> I've reset overlayfs-next to no-rebase-overlayfs, as it  had my version
> with removal so far.
> 
> For the final update, I doubt I will need to include it at all, because
> the chances of ovl_obtain_alias() colliding with anything for the next
> cycle are pretty slim, but it's good that I have the option and I will
> anyway make sure to always test the next update with this change.

OK...  Several overlayfs locking questions:
ovl_indexdir_cleanup()
{
	...
	inode_lock_nested(dir, I_MUTEX_PARENT);
	...
		index = ovl_lookup_upper(ofs, p->name, indexdir, p->len);
		...
                        err = ovl_cleanup_and_whiteout(ofs, dir, index);

with ovl_cleanup_and_whiteout() moving stuff between workdir and parent of index.
Where do you do lock_rename()?  It's a cross-directory rename, so it *must*
lock both (and take ->s_vfs_rename_mutex as well).  How can that possibly
work?

Similar in ovl_cleanup_index() - you lock indexdir, then call
ovl_cleanup_and_whiteout(), with the same locking issues.

Another fun question: ovl_copy_up_one() has
        if (parent) {
                ovl_path_upper(parent, &parentpath);
                ctx.destdir = parentpath.dentry;
                ctx.destname = dentry->d_name;

                err = vfs_getattr(&parentpath, &ctx.pstat,
                                  STATX_ATIME | STATX_MTIME,
                                  AT_STATX_SYNC_AS_STAT);
                if (err)
                        return err;
        }
What stabilizes dentry->d_name here?  I might be missing something about the
locking environment here, so it might be OK, but...

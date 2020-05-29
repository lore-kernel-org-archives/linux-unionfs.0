Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42EAC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 19:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8112074B
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 19:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G68WTzAG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgE2TBF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 15:01:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48733 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgE2TBF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 15:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590778863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJcU36E55KdPN4WS+7qXZTFYC8q/n4F6+8jUz1KBrYo=;
        b=G68WTzAG6WbWxt1oc7HkCprWbRnRSgqIC4P2dUDp4DMQ2fiGM1T697hFHDz6gLxroBMhnl
        S8VThKjcu19CaQ3BHu6eoF7tg7g+UiDazrQgzgPFuwwIaZiIjEdpmRq9K6abYzH1njIRG7
        vF6KS134cdOaDBBgGXVFjul4KKzWVkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-5jmWMgFyPyugJgMa8zj8_w-1; Fri, 29 May 2020 15:01:00 -0400
X-MC-Unique: 5jmWMgFyPyugJgMa8zj8_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 868FB19057A2;
        Fri, 29 May 2020 19:00:59 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 189DC10013C2;
        Fri, 29 May 2020 19:00:59 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8A69122066B; Fri, 29 May 2020 15:00:58 -0400 (EDT)
Date:   Fri, 29 May 2020 15:00:58 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200529190058.GB196987@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com>
 <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
 <20200528173512.GA167257@redhat.com>
 <CAOQ4uxhnsc8AHfeQJ-eHFEjyONRF5bXBvRd-D29Nao4Bz8EM0g@mail.gmail.com>
 <20200529141623.GA196987@redhat.com>
 <CAOQ4uxhie2s+yvF1jpPnh6-+a-r8kz589Y5znAX_jmeWqo+SCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhie2s+yvF1jpPnh6-+a-r8kz589Y5znAX_jmeWqo+SCQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 29, 2020 at 06:46:43PM +0300, Amir Goldstein wrote:
> > > > @@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
> > > >          *
> > > >          * Always lookup index of non-dir non-metacopy and non-upper.
> > > >          */
> > > > -       if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
> > > > +       if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
> > > >                 origin = stack[0].dentry;
> > > >
> > >
> > > I think this should be:
> > >
> > >           * Always lookup index of non-dir and non-upper.
> > >           */
> > >           if (!origin && ctr && (!upperdentry || !d.is_dir))
> > >                  origin = stack[0].dentry;
> > >
> > > uppermetacopy is guaranteed to either have origin already set or
> > > exit with an an error for ovl_verify_origin().
> >
> > Only if index is enabled and upper had origin xattr.
> >
> > (!d.is_dir && ofs->config.index && origin_path)
> >
> > So if index is disabled or uppermetacopy did not have "origin" xattr,
> > we will not have origin set by the time we come out of the loop.
> >
> 
> True. But if index is disabled, setting origin is moot. origin is only
> ever used here to lookup the index.

Well, while looking up for index, we are checking for presence of
index dir (and not checking whether index is currently enabled or
not). So if somebody mounts overlayfs with index=on and later remounts
with index=off, we can still start looking up the index even if it
is not enabled. Is it intentional? If not, to simplify it, should
we lookup index only if it is enabled.

        if (origin && ofs->config.index &&
            (!d.is_dir || ovl_index_all(dentry->d_sb))) {
                index = ovl_lookup_index(ofs, upperdentry, origin, true);


> 
> About "origin" xattr. If it is not set in upper that lower fs probably does
> not have file handle support. In that case, index cannot be enabled
> anyway.

What about the case of multiple lower layers. IIUC, we will only 
ensure that top most lower layer has file handle support and not
worry about rest of the layers. This will break the case of setting
origin for !upperdentry. This will lookup index and fail if lower
layer does not support file handle.

So may be while enabling index, we should make sure all lower
layers support file handles otherwise fail?

> 
> > I see for non-metacopy regular files, if upper did not have origin
> > xattr, that means origin_path will by NULL. That means ctr will be
> > 0 and that means we will not set "origin" for non-metacopy regular
> > files in such case. So question is, should we set "origin" for
> > metacopy upper files in such a case.
> >
> > We did not have origin xattr, but we looked up lower layers for
> > upper metacopy. In theory, stack[0].dentry is origin for upper
> > metacopy files. Should we use it? Current logic does not and that's
> > why this additiona check (!d.is_dir && !uppermetacopy).
> >
> 
> I agree with your analysis, but this is a very theoretical discussion.
> Unless I am missing something, I think we have written a very complex
> condition for a corner case that doesn't seem to be valid or interesting.

I agree. I want to simplify it too. Just trying to make sure that
I don't end up breaking some valid configuration.

> 
> Basically, for non-dir, if there is no "origin" xattr, then there should be no
> index, because the metacopy feature was added way long after we
> started storing "origin" on copy up. That's not the case for directories.
> 
> There is one corner case where it may be relevant -
> overlay layers with metacopy that were created on fs with no file handle
> support (or no uuid) that are migrated to a filesystem with file handle
> support (and metacopy xattr are preserved in migration).
> In that case, index may be enabled while upper metacopy exists
> without "origin".
> 
> What happens if we do not set origin and do not lookup index in that case?
> We can get two overlay inodes, both from different metacopy upper inodes
> redirected to the same lower inode, that have the same st_ino, but differnt
> metadata.

We do not set origin on upper for broken hardlinks. So we will report
inode number from upper. I tried. it.

I tried following.

- touch foo.txt
- ln foo.txt foo-link.txt
- mount with metacopy=on
- chwon test:test foo.txt
- umount
- Goto upper/ and remove origin xattr from foo.txt. But there should not
  be one because we do not create ORIGIN for broken hardlinks if index is
  not enabled.
- mount overlay with index=on
- Do stat on foo.txt and foo-link.txt. foo.txt reports inode number from
  upper and foo-link.txt reports inode number from lower.
- chown test:test foo-link.txt
- stat foo-link.txt still reports inode number from lower.

Anyway, at this point of time, how about following.

- For non-upper dentry, always set origin.
- For upperdentry, there are 3 cases.
	- directories
	- regular files
	- regular metacopy files

  For directories and regular metacopy files only use verified origin.
  That means upper has origin xattr and it matches patch based looked
  up dentry. If we did not verify because either ORIGIN xattr is not
  there, or because index is not enabled or because ovl_verify_lower()
  is not set, then don't use path based looked up dentry as origin.

  For the case of regular file upper dentry, use unverified origin.
  It implies that ORGIN xattr is there. As there is no path based
  lookup origin for upper regular files. 

I am attaching a simple patch. Please let me know what do you think
of it.

> 
> > >
> > > HOWEVER, if we set origin to lower, which turns out to be a lower
> > > metacopy, we then skip this layer to the next one, but origin remains
> > > set on the skipped layer dentry, which we had already dput().
> > > Ay ay ay!
> >
> > We only skip the intermediate metacopy entries in lower. So top most
> > lower metacopy will still be retained. For example, if there are 3
> > lower layers where top two are metacopy and one data, then we will
> > only skip middle one. And middle one should not be origin for upper.
> >
> >                 /*
> >                  * Do not store intermediate metacopy dentries in chain,
> >                  * except top most lower metacopy dentry
> >                  */
> >                 if (d.metacopy && ctr) {
> >                         dput(this);
> >                         continue;
> >                 }
> >
> > For the first lower, ctr will be 0 and we will always store it in
> > stack. So if it is metacopy dentry, it will still be stored at
> > stack[0].
> >
> > Do you still see the problem?
> 
> No. it's fine. My eyes missed the ctr condition.
> I still think since you are changing this code.
> It will be much easier to follow if both simple continue statement
> are at the top of the loop.

Ok, will do.

Here is the patch to simplify the condition or origin. I will add some
changelog and comments in code in v2 of patch if you like the patch.

Thanks
Vivek


---
 fs/overlayfs/namei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: redhat-linux/fs/overlayfs/namei.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/namei.c	2020-05-29 14:24:45.997113946 -0400
+++ redhat-linux/fs/overlayfs/namei.c	2020-05-29 14:46:46.692113946 -0400
@@ -1005,6 +1005,7 @@ struct dentry *ovl_lookup(struct inode *
 		}
 		stack = origin_path;
 		ctr = 1;
+		origin = origin_path->dentry;
 		origin_path = NULL;
 	}
 
@@ -1021,9 +1022,9 @@ struct dentry *ovl_lookup(struct inode *
 	 * index. This case should be handled in same way as a non-dir upper
 	 * without ORIGIN is handled.
 	 *
-	 * Always lookup index of non-dir non-metacopy and non-upper.
+	 * Always lookup index of non-upper.
 	 */
-	if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
+	if (!origin && ctr && !upperdentry)
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&


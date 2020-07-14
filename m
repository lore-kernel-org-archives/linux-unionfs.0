Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EBDC433EA
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 16:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 528CC22464
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 16:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DC2uR3xf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgGNQWc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:22:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725876AbgGNQWb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 12:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594743748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ML29heeU9wazIqxvXYIYzi6qJB/+D+f+ATOrUfiIUbM=;
        b=DC2uR3xf0WiL+Ru5LEZHNI7RlHOkO6pel4f2ktesiTJEdXewbnFpiH0MlG+39nEkjuSaxN
        sz/x5KaQtwpaYwtCpEw0qGkmz6MzHJmjl4w3Fr/9/48HSZ4CUkPZ329FlhrDc8rDm6yxE0
        WJgMc+OQkI5omxhmR9yQnzeaFzq/yGM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-TXfc3X7WMNCV_HYqvobJYg-1; Tue, 14 Jul 2020 12:22:16 -0400
X-MC-Unique: TXfc3X7WMNCV_HYqvobJYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D213D8015F4;
        Tue, 14 Jul 2020 16:22:14 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-205.rdu2.redhat.com [10.10.115.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A6DB5C1B2;
        Tue, 14 Jul 2020 16:22:14 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A08A12237D7; Tue, 14 Jul 2020 12:22:13 -0400 (EDT)
Date:   Tue, 14 Jul 2020 12:22:13 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH RFC 0/2] Invalidate overlayfs dentries on underlying
 changes
Message-ID: <20200714162213.GD324688@redhat.com>
References: <20200713105732.2886-1-amir73il@gmail.com>
 <CAOQ4uxg9PWi+645+zeH77FKQwi+RJ6bFugqG8Zv6qpPPJuTPnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg9PWi+645+zeH77FKQwi+RJ6bFugqG8Zv6qpPPJuTPnQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 12:29:08PM +0300, Amir Goldstein wrote:
> On Mon, Jul 13, 2020 at 1:57 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Miklos,Vivek,
> >
> > These patches are part of the new overlay "fsnotify snapshot" series
> > I have been working on.
> >
> > Conterary to the trend to disallow underlying offline changes with more
> > configurations, I have seen that some people do want to be able to make
> > some "careful" underlying online changes and survive [1].
> >
> > In the following patches, I argue for improving the robustness of
> > overlayfs in the face of online underlying changes, but I have not
> > really proved my claims, so feel free to challenge them.
> >
> 
> This wasn't actually working unless underlying fs was remote, because
> overlayfs clears the DCACHE_OP_REVALIDATE flags in that case.
> 
> I added this hunk for revalidate of local lower fs with nfs_export=on:
> 
> @@ -111,6 +111,10 @@ void ovl_dentry_update_reval(struct dentry
> *dentry, struct dentry *upperdentry,
>         for (i = 0; i < oe->numlower; i++)
>                 flags |= oe->lowerstack[i].dentry->d_flags;
> 
> +       /* Revalidate on local fs lower changes */
> +       if (oe->numlower && ovl_verify_lower(dentry->d_sb))
> +               flags |= mask;
> +
> 
> 
> > I also remember we discussed several times about the conversion of
> > zero return value to -ESTALE, including in the linked thread.
> > I did not change this behavior, but I left a boolean 'strict', which
> > controls this behavior. I am using this boolean to relax strict behavior
> > for snapshot mount later in my snapshot series. Relaxing the strict
> > behavior for other use cases can be considered if someone comes up with
> > a valid use case.
> >
> 
> After giving this some more though, I came to a conclusion that it is actually
> wrong to convert 0 to error because 0 could mean cache timeout expiry
> or other things that do not imply anyone has made underlying changes.
> I see that fuse_dentry_revalidate() handles timeout expiry internally and
> other network filesystems may also do that, but there is nothing in the
> "contract" about not returning 0 if entry MAY be valid.
> Am I wrong?
> 
> I can even think of a network filesystem that marks its own dentry for lazy
> revalidate after some local changes, so this behavior is even more dodgy
> when dealing with remote upper fs.
> 
> So I added another patch to remove the conversion 0 => -ESTALE.
> 
> Pushed these patches to
> https://github.com/amir73il/linux/commits/ovl-revalidate:
>  ovl: invalidate dentry if lower was renamed
>  ovl: invalidate dentry with deleted real dir
>  ovl: do not return error on remote dentry cache expiry

So what's the end goal. We don't want to return error during lookup,
if underlying layer changed and instead force re-lookup. And re-lookup
might work in a slightly different way and that's allowed?

IOW, we don't want to return error if we detected lower layer change
and just continue to run. It might fail later or it might subtly
change behavior in some way (inode number reporting etc). But that's
fine?

What will documentation says. Lower layer changes are allowed? Or
we say lower layer changes are not allowed but overlay will not
flag it at runtime even if we detect it.

Thanks
Vivek


Return-Path: <SRS0=C3ej=B3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E7EC433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Aug 2020 13:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7A92075B
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Aug 2020 13:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ULuHQmj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgHQN5N (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 09:57:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728741AbgHQN47 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Aug 2020 09:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597672615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=taFjIQk+/ikKdZMAHZIANUtJctLLe1i5NbPKPnX2PuI=;
        b=ULuHQmj92zqs/ZWXvkYBjB+NXEpcXMBfZ/1k6PWJLwW9HiuiHF3uOp5dhZsjojTLVOAoaw
        7Dmc5BhzuOpFDCAoqNFEtROySrn21Ak0/3hzxuXVVkiYnS31ggdScG+0ap3RcTB3RZeIId
        gPRb/67dbMU8LLu/XKZKoHwgiN/rDOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-212E1Wh2NregciZaCwNdPg-1; Mon, 17 Aug 2020 09:56:53 -0400
X-MC-Unique: 212E1Wh2NregciZaCwNdPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 822F2100CF71;
        Mon, 17 Aug 2020 13:56:52 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-81.rdu2.redhat.com [10.10.115.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFE625C3E1;
        Mon, 17 Aug 2020 13:56:51 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 76C38222E58; Mon, 17 Aug 2020 09:56:51 -0400 (EDT)
Date:   Mon, 17 Aug 2020 09:56:51 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: EIO for removed redirected files?
Message-ID: <20200817135651.GA637139@redhat.com>
References: <20200812135529.GA122370@kevinolos>
 <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
 <20200812160513.GA249458@kevinolos>
 <CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 12, 2020 at 08:06:34PM +0300, Amir Goldstein wrote:
> On Wed, Aug 12, 2020 at 7:05 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> >
> > Thanks for the quick response Amir!
> >
> > On Wed, 2020-08-12 at 18:21 +0300, Amir Goldstein wrote:
> > > On Wed, Aug 12, 2020 at 5:06 PM Kevin Locke <kevin@kevinlocke.name> wrote:
> > >> I recently encountered files on an overlayfs which returned EIO
> > >> (Input/output error) for open, stat, and unlink (and presumably other)
> > >> syscalls.  I eventually determined that the files had been redirected
> > >
> > > It's *empty* redirected files that cause the alleged problem.
> >
> > When I replace `touch foo.txt` with `echo 123 > foo.txt` I observe the
> > same behavior.  If I understand you correctly, you are saying that EIO
> > is correct for non-empty files, but potentially incorrect for empty
> > files (which could be copied rather than redirected, since there is no
> > space saving)?
> >
> 
> I wouldn't call it "incorrect" more like "unnecessary".
> 
> > >> At this point, the only way to recover appears to be unmounting the
> > >> overlay and removing the file from upper (or updating the
> > >> overlay.redirect xattr to a valid location).  Is that correct?
> > >>
> > >> Is this the intended behavior?
> > >
> > > Yes.
> > > What would you expect to happen when data of metacopy file has been removed?
> >
> > After reflection, EIO probably makes the most sense for open/stat.  It
> > might be nice to be able to unlink the file to allow recovery (in the
> > sense of being able to reuse the name) without unmounting the overlay,
> 
> It would be nice, but somebody needs to care enough to implement it
> and it is not going to be trivial, because error on lookup is much easier
> then selective error on a "broken" dentry depending on the operation...
> 
> > but the documentation updates may be sufficient to keep users from
> > getting into this state.
> >
> > >> unionmount-testsuite.  If so, perhaps the behavior could be noted in
> > >> "Changes to underlying filesystems" in
> > >> Documentation/filesystems/overlayfs.rst?  I'd be willing to write a
> > >> first draft.  (I doubt I understand it well enough to get everything
> > >> right on the first try.)
> > >
> > > I guess the only thing we could document is that changes to underlying
> > > layers with metacopy and redirects have undefined results.
> > > Vivek was a proponent of making the statements about outcome of
> > > changes to underlying layers sound more harsh.
> >
> > That sounds good to me.  My current use case involves offline changes to
> > the lower layer on a routine basis, and I interpreted the current
> 
> You are not the only one, I hear of many users that do that, but nobody ever
> bothered to sit down and document the requirements - what exactly is the
> use case and what is the expected outcome.
> 
> > wording "Offline changes, when the overlay is not mounted, are allowed
> > to either the upper or the lower trees." to mean that such offline
> > modifications would not break things in unexpected ways.
> >
> 
> The truth is that this documentation is old, before all the new features
> were added. See here [1], Vivek suggested:
> "Modifying/recreating lower layer only works when
>  metacopy/index/nfs_export are not enabled at any point of time. This
>  also will change inode number reporting behavior."
> 
> > In retrospect, I should have expected this behavior, but as someone
> > previously unfamiliar with overlayfs, I hadn't considered that metacopy
> > results in file redirects and that if the underlying file were removed
> > without removing any redirects pointing to it that it would manifest in
> > this way and be so difficult to clean up.
> >
> > If metacopy and dir_redirect are disabled, are offline modifications to
> > the lower layer permitted, or could any such modification result in
> > undefined behavior?
> >
> 
> With metacopy/index/nfs_export/redirect_dir disabled code behaves mostly
> like it did at the time that this documentation was written, so I guess you may
> say that changes are permitted and result in "defined" behavior.

I still think that we should make it clear in documentation that
modifying and recreating lower layers is not allowed when advanced
features like metacopy/index/nfs_export/redirect_dir are enabled. If
one does so, expect the unexpected.

https://lore.kernel.org/linux-unionfs/20200709153616.GE150543@redhat.com/T/#t

To me, if we allow any random modification/recreation of lower filesystem,
then definiting the behavior in all the corner cases becomes hard and
it also makes design of overlayfs more complicated because anytime you
are implementing something, now you have to worry about modifications to
lower layer as well.

And I am also not aware of any good use cases which justify supporting
lower layer modification with new features. So remain of the opinion
that don't support it.

Thanks
Vivek


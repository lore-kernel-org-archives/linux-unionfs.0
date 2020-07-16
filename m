Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AD4C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F50220760
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMnjeHGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgGPN1t (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:27:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728248AbgGPN1s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 09:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594906067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2DpcnHmBCFXpU5RsivSoJZI/dcs6lw01BCUSAkRxywc=;
        b=bMnjeHGOSXH6Guc9D7UjIpBz/iR6Qr5BQuBsjEVQpKBV1nSQzWOp4Ef1dUzBPNVNbjW5OU
        vE6iVgJA5eHMUzBMTtZxy5a0F9157cUU9bYI1vupBRs+qC3YiZp4Bi1WI/HSHHbudqQO0h
        8JNyU9VwdGcd300ghpO0EMHCnRyyekY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-YSAGHjIaM8if5PjyZxOV8g-1; Thu, 16 Jul 2020 09:27:45 -0400
X-MC-Unique: YSAGHjIaM8if5PjyZxOV8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C060107BEF6;
        Thu, 16 Jul 2020 13:27:44 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-241.rdu2.redhat.com [10.10.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F24BA17D04;
        Thu, 16 Jul 2020 13:27:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 8D3BC225777; Thu, 16 Jul 2020 09:27:43 -0400 (EDT)
Date:   Thu, 16 Jul 2020 09:27:43 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
Message-ID: <20200716132743.GB422759@redhat.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
 <20200714180705.GE324688@redhat.com>
 <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com>
 <20200715130648.GA379396@redhat.com>
 <CAOQ4uxjV93TAUGLAL_1uAtm2+eJv7poj_mmO5K_-07TYjBh7vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjV93TAUGLAL_1uAtm2+eJv7poj_mmO5K_-07TYjBh7vA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 15, 2020 at 04:56:45PM +0300, Amir Goldstein wrote:
> > > TBH I never really understood the thread that led to redirect_dir=nofollow.
> > > I don't think anyone has presented a proper use case that can be discussed,
> >
> > IIUC, idea was that automated mounting can mount a handcrafted upper on
> > usb hence allow access to directories on host which are otherwise
> > inaccessible.
> >
> 
> That is an *idea* described by hand waving.
> That is not a threat I can seriously comment on.
> How exactly is that USB auto mounted? where to?
> How is that related to overlay?
> 
> > > so I just treat this config option as "paranoia" or "don't give me anything that
> > > very old overlay did not give me".
> > > Therefore I suggested piggybacking on it.
> >
> > Even if it is paranoia, put more unrelated checks under this option does
> > not make much sense to me. It will make things just more confusing.
> >
> > Anyway, redirect_dir=nofollow is a thing of past. Now if you want to
> > not follow origin, then we first need to have a genuine explanation
> > of why to do that (and not be driven by just paranoia).
> >
> > > Of course if we do, we will need to document that.
> >
> > redirect_dir=nofollow resulting in origin not being followed is plain
> > unintuitive to me. Why not introduce another option if not following
> > origin is so important.
> >
> 
> Because cluttering the user with more and more config options for
> minor and mostly unimportant behaviors is not ideal either.
> See what Kconfig help has to say about the config option:
> 
> config OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
>         bool "Overlayfs: follow redirects even if redirects are turned off"
>         default y
> 
>        Disable this to get a possibly more secure configuration, but that
>        might not be backward compatible with previous kernels.
> 
> That is a VERY generic description that fits not following origin very
> well IMO, and not following unverified dir origin as well for that matter.
> Nobody outside overlayfs developers knows what "redirects" means
> anyway. To me, following non-dir origin sounds exactly the same
> as following non-dir metacopy redirect or dir redirect. It's just the
> implementation details that differ.
> 
> So my claim is that we *can* piggyback on it because I really
> don't believe anybody is using this config out there for anything
> other than "to be on the safe side".

On one hand you are saying redirect=nofollow is paranoia, most people
don't understand it and don't use it. And on top of that you want
to add more to it. Adding more to something which nobody does not
understand and uses, sounds like more trouble to me.

Anyway, before we go further into this, what's the use case. Why
do you want to provide option to disable following origin for non-dir?

Thanks
Vivek

> 
> But I do not make the calls here and it doesn't look like I managed
> to convince you to take my side of the argument :-)
> 
> Thanks,
> Amir.
> 


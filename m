Return-Path: <SRS0=S/v9=A2=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69175C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 439EB20657
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Jul 2020 13:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ci+kG1R9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgGONGz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 09:06:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729900AbgGONGy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Jul 2020 09:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594818413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cYYNklSRyst0chBGlXKSwNH81G6x0gsz7iHRK5Sk6GA=;
        b=ci+kG1R9kqyrdtPVOapD4qIuh9GEH6E2lbFtmCPmKtsopscmJojyvcmaq6wefU10A6ZpxC
        1Tc4gwwsUhHb0khnSA9xvDAl9MjWQeLLgrntpxJX01L3onXNpWl0P6MgX4aG3VDuCP6Qc7
        5PCbrkKBxzhNMjZRylIFYUWFSLIG69I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-_q-oc1HYPtSA7AYsxTND2A-1; Wed, 15 Jul 2020 09:06:51 -0400
X-MC-Unique: _q-oc1HYPtSA7AYsxTND2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB9F018FF669;
        Wed, 15 Jul 2020 13:06:49 +0000 (UTC)
Received: from horse.redhat.com (ovpn-113-0.rdu2.redhat.com [10.10.113.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0584479501;
        Wed, 15 Jul 2020 13:06:49 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7C207220CD1; Wed, 15 Jul 2020 09:06:48 -0400 (EDT)
Date:   Wed, 15 Jul 2020 09:06:48 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] Misc. redirect_dir=nofollow fixes
Message-ID: <20200715130648.GA379396@redhat.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
 <20200714180705.GE324688@redhat.com>
 <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh-fUKhiQOhRmZ5LT2sjtM3Wx5wo_wcKYtX+-DbYjXp0Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 09:42:53PM +0300, Amir Goldstein wrote:
> On Tue, Jul 14, 2020 at 9:07 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Jul 13, 2020 at 05:19:42PM +0300, Amir Goldstein wrote:
> > > Miklos, Vivek,
> > >
> > > Following discussion on following an unsafe non-dir origin [1]
> > > and in a addition to a fix for the reported null uuid case [2] and to
> > > Vivek's doc clarification [3], I am proposing to piggy back existing
> > > config redirect_dir=nofollow to also not follow non-dir origin.
> > >
> > > Like in the case of non-dir origin, following redirects behavior was
> > > added with no opt-out option in kernel v4.10.  Later security concerns
> > > about following malformed redirects resulted in the redirect_dir=nofollow
> > > config option.
> >
> > So what's the security issue you are seeing with malformed origin? If
> 
> TBH I never really understood the thread that led to redirect_dir=nofollow.
> I don't think anyone has presented a proper use case that can be discussed,

IIUC, idea was that automated mounting can mount a handcrafted upper on
usb hence allow access to directories on host which are otherwise
inaccessible. 

> so I just treat this config option as "paranoia" or "don't give me anything that
> very old overlay did not give me".
> Therefore I suggested piggybacking on it.

Even if it is paranoia, put more unrelated checks under this option does
not make much sense to me. It will make things just more confusing.

Anyway, redirect_dir=nofollow is a thing of past. Now if you want to
not follow origin, then we first need to have a genuine explanation
of why to do that (and not be driven by just paranoia).

> Of course if we do, we will need to document that.

redirect_dir=nofollow resulting in origin not being followed is plain
unintuitive to me. Why not introduce another option if not following
origin is so important.

Thanks
Vivek

> BTW, I have another patch that does not follow mismatched lower dir origin
> with redirect_dir=nofollow, i.e.:
> 
>  bool ovl_verify_lower(struct super_block *sb)
>  {
>         struct ovl_fs *ofs = sb->s_fs_info;
> 
> -       return ofs->config.nfs_export && ofs->config.index;
> +       return ofs->config.nfs_export || !ofs->config.redirect_follow;
>  }
> 
> That makes even more sense for "paranoia" IMO.
> 
> Thanks,
> Amir.
> 


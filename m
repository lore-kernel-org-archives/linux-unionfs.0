Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5271AC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2953464E70
	for <linux-unionfs@archiver.kernel.org>; Thu, 11 Feb 2021 17:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhBKQ7v (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:59:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232105AbhBKQ5u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 Feb 2021 11:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613062582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o5cm5+imUOL6kPKL0q+3bs7oEN4BvQDBMHj3dTRfgsE=;
        b=QgdUPPLjFlaSb1ntxgoZmAzdgNgZ2c0qlQkqF9K0GxME/+AlDdmnZgiq25+CwLVMsVTPAR
        SkY+KUaAbCuCAHibQ6JJl9fEKApAjRWc8h/LT2KGlYuWR1B8Z4POCmfe51BpIl3oVg7Iur
        JCSLaD1LqxwsJMsbfb3oM8iFp8Prf2E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-YiE5SC_1NQm2I2IBscF98Q-1; Thu, 11 Feb 2021 11:56:19 -0500
X-MC-Unique: YiE5SC_1NQm2I2IBscF98Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDD4D107ACE4;
        Thu, 11 Feb 2021 16:56:17 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-229.rdu2.redhat.com [10.10.115.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 622E110016F5;
        Thu, 11 Feb 2021 16:56:17 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E7688220BCF; Thu, 11 Feb 2021 11:56:16 -0500 (EST)
Date:   Thu, 11 Feb 2021 11:56:16 -0500
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>
Subject: Re: [PATCH] selinux: Allow context mounts for unpriviliged overlayfs
Message-ID: <20210211165616.GD5014@redhat.com>
References: <20210209200233.GF3171@redhat.com>
 <CAHC9VhQYE3ga53AiK2r-568_=2U0BJe+L4g9U_J0dLinzJqXYA@mail.gmail.com>
 <20210211140147.GA5014@redhat.com>
 <CAHC9VhS=GkB2JbSz++iTygGzb2Ze6WVKuj5rnNaNVTN=p7=dCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS=GkB2JbSz++iTygGzb2Ze6WVKuj5rnNaNVTN=p7=dCQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Feb 11, 2021 at 11:32:41AM -0500, Paul Moore wrote:
> On Thu, Feb 11, 2021 at 9:01 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Feb 10, 2021 at 06:50:57PM -0500, Paul Moore wrote:
> > > On Tue, Feb 9, 2021 at 3:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > > Now overlayfs allow unpriviliged mounts. That is root inside a non-init
> > > > user namespace can mount overlayfs. This was added in 5.10 kernel.
> >
> > Actually this is being added in 5.11 kernel (and not 5.10 kernel).
> >
> > Paul, can you please fix this while committing. If you want me to
> > report, let me know.
> 
> Good to know, thanks for the clarification.  As far as updating the
> commit description, while I generally prefer the patch author to make
> changes (my personal opinion is that maintainers should have as light
> a touch as possible outside the mechanical work of merging), this is
> pretty minor and I can fix that up if you want.  Regardless, we've
> likely got ~2.5 weeks before it really matters anyway :)

Ok, I will repost. Want to keep it as simple as possible for you. :-)

Vivek

> 
> -- 
> paul moore
> www.paul-moore.com
> 


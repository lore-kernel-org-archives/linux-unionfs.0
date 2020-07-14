Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81270C433E3
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F382242E
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 18:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fkjy7DQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGNSi1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 14:38:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26734 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725951AbgGNSi0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 14:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594751905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GWNaN3K0SVCALg+4a8JOeR1J8oh9MlnJH5eUsWSAFOU=;
        b=Fkjy7DQ+1Qlfts++LxA5ZAIyKyCA+mjp7kf66KT6mB1E8r5iIml3W4x5J/yXYQkqR2B6Fi
        ph7qJ95UrcIDbojP27mqoXNS4V+OoeCAx69sXGpA4lFGfe/RcReZVYG2LmR7mMKVuMRK/s
        kFHlpgKOn5bPhLBDTHDJf4thobrpTF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-S1Uv59tZPg-N8FRHne2jAg-1; Tue, 14 Jul 2020 14:38:20 -0400
X-MC-Unique: S1Uv59tZPg-N8FRHne2jAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E58061081;
        Tue, 14 Jul 2020 18:38:19 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-205.rdu2.redhat.com [10.10.115.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC07E7980F;
        Tue, 14 Jul 2020 18:38:19 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6429D2237D7; Tue, 14 Jul 2020 14:38:19 -0400 (EDT)
Date:   Tue, 14 Jul 2020 14:38:19 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] ovl: force read-only sb on failure to create index
 dir
Message-ID: <20200714183819.GH324688@redhat.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
 <20200713141945.11719-2-amir73il@gmail.com>
 <20200714181804.GF324688@redhat.com>
 <CAOQ4uxj_GMcWvSGSWkTQvKj2gPCP1=R9T-t=baDrH+V3Q1mPrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj_GMcWvSGSWkTQvKj2gPCP1=R9T-t=baDrH+V3Q1mPrQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jul 14, 2020 at 09:32:51PM +0300, Amir Goldstein wrote:
> On Tue, Jul 14, 2020 at 9:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Mon, Jul 13, 2020 at 05:19:43PM +0300, Amir Goldstein wrote:
> > > With index feature enabled, on failure to create index dir, overlay
> > > is being mounted read-only.  However, we do not forbid user to remount
> > > overlay read-write.  Fix that by setting ofs->workdir to NULL, which
> > > prevents remount read-write.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >
> > This patch does not apply for me. What branch you have generated it
> > against. I am using 5.8-rc4.
> 
> It's from my ovl-fixes branch.
> 
> Sorry I did not notice that it depends on a previous patch that Miklos
> just picked up:
> 
> "ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on"

I dont see it here.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git/log/?h=overlayfs-next

Is there another tree/branch miklos is maintaining which I should use? Or
you just happen to know that Miklos has committed this internally and
not published yet.

Thanks
Vivek


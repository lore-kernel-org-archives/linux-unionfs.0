Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72345C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F9120708
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rie5++vW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgGFQGy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:06:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729293AbgGFQGx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 12:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594051612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sUCZlzPweoo2TxmnbuuYK5ohJTDiKmL946D5obXZcGs=;
        b=Rie5++vWcShPrVtWJ69dwXGE3LmGCybpieSFYSW8hcFXTumjj82KH1WFupgGAoHuhD+jyr
        mP9Ydr3YrPF9/Cy2C7xLBfcOb5qsz1gToNOzCFkLOSufFK8txP3nd/PMXjBKZls8/AFsdQ
        7YcKRX+FJzDB7jTQr0/kSH5Pc0xn2Ak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-ejPIrb1kMWuCwmkB9P4okw-1; Mon, 06 Jul 2020 12:06:50 -0400
X-MC-Unique: ejPIrb1kMWuCwmkB9P4okw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AADED107ACCA;
        Mon,  6 Jul 2020 16:06:49 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-136.rdu2.redhat.com [10.10.115.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2E479249;
        Mon,  6 Jul 2020 16:06:46 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A720422055E; Mon,  6 Jul 2020 12:06:45 -0400 (EDT)
Date:   Mon, 6 Jul 2020 12:06:45 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, pmatilai@redhat.com
Subject: Re: [RFC PATCH v3] overlayfs: Provide mount options sync=off/fs to
 skip sync
Message-ID: <20200706160645.GA3107@redhat.com>
References: <20200701215029.GF369085@redhat.com>
 <CAOQ4uxhLe3ptTcdsyGXRB=w3ub5_is3HcUY0z7OLgLPDg1Mk5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhLe3ptTcdsyGXRB=w3ub5_is3HcUY0z7OLgLPDg1Mk5w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 02, 2020 at 10:26:44AM +0300, Amir Goldstein wrote:
[..]
> If you use bitwise flags, they reflect the ovl_should_xxx queries:
> __OVL_NOSYNC_FILE and __OVL_NOSYNC_FS
> #define OVL_SYNC_FILE(type)     (!((type) & __OVL_NOSYNC_FILE))
> #define OVL_SYNC_FS(type)      (!((type) & __OVL_NOSYNC_FS))
> 
> 
> If you use enum (not bitwise), the distinct enum values reflect the
> mount option:
> OVL_SYNC_ON (=0), OVL_SYNC_OFF, OVL_SYNC_FS
> 
> I am not commenting on this because of some sort of aesthetic taste.
> I am commenting on this because I think it would make parts of the
> patch simpler/clearer (see below).
> 
> As far as I am concerned, for the three possible config values off/fs/on
> the distinct enum values are better.
> Of course, that is *my* opinion. You may disagree.

Hi Amir,

I kept bitwise flags because you had mentioned sync=writeback and this
can co-exist with sync=fs. May be somebody wants sync=copyup down the
line. Though we have not implemented sync=writeback
yet, I thought keeping a bitwise flag will help support multiple sync
options at the same time.

Anyway, sync=off/fs are mutually exclusive and don't need bitwise
flags. So for now I will convert this to just enum. When sombody
introduces a sync option which can co-exist with existing options,
they will need to use bit flags.


[..]
> > +               seq_puts(m, ",sync=fs");
> 
> option #1 (bitwise):
>        if (!ofs->config.sync)
>                seq_puts(m, ",sync=off");
>       else if (!OVL_SYNC_FILE(ofs->config.sync))
>                seq_puts(m, ",sync=fs");
> 
> option #2 (distinct):
> Would be better. See ovl_xino_str[].

Will do.

[..]
> > @@ -588,6 +608,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >                 config->workdir = NULL;
> >         }
> >
> > +       if (OVL_SYNC_OFF(config->sync) && OVL_SYNC_FS(config->sync)) {
> > +               pr_err("conflicting options: sync=off,sync=fs\n");
> > +               return -EINVAL;
> > +       }
> > +
> 
> We are not warning user that metacopy=off conflicts with metacopy=on,
> we just let the last option overwrite previous ones.

Ok, will drop this check.

Thanks
Vivek


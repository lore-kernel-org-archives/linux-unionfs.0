Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1B3C4320A
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 19:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58F346101D
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Aug 2021 19:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhHIT5K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:57:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233546AbhHIT5K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Aug 2021 15:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628539009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AwvrxlzQhyUHyIFTZNnLnBfHFOFKtCqG67vX2dUCkoQ=;
        b=YXUS6VkxcJRi8HWd1l3etHlpQXCVop4FbWykw4VEznDwYoE5+HeLHH/ixNkzgNdHphdXJF
        uwtB+Qnz627n+/m1p6qTZ/GzZw2mhPcqjo0N+EH8Wr31aj553g1qyFMgwSwOHWX/L09PHA
        g06DWT5eB/VjqB1eiycFmd0u2pYBAWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-bIUz3rgoMEqd64HSi4WOPg-1; Mon, 09 Aug 2021 15:56:45 -0400
X-MC-Unique: bIUz3rgoMEqd64HSi4WOPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82832101C8A0;
        Mon,  9 Aug 2021 19:56:44 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.10.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 424FB19CBA;
        Mon,  9 Aug 2021 19:56:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id D5303220261; Mon,  9 Aug 2021 15:56:42 -0400 (EDT)
Date:   Mon, 9 Aug 2021 15:56:42 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and
 metacopy?
Message-ID: <YRGIevRDg6hrdYQl@redhat.com>
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 07, 2021 at 02:05:15PM +0300, Amir Goldstein wrote:
> On Sat, Aug 7, 2021 at 1:17 PM Zhihao Cheng <chengzhihao1@huawei.com> wrote:
> >
> > Hi, all.
> >
> > As title said. I wonder to know the reason for overlayfs mount failure
> > with '-o nfs_export=on,metacopy=on'.
> >
> > I modified kernel to enable these two options 'on',  it looks like that
> > overlayfs can still work fine under nfs_v4.
> >
> > Besides, I can get no more information about the reason from source
> > code, maybe I missed something.
> >
> 
> It's because ovl_obtain_alias() (decoding a disconnected non-dir file handle)
> does not know how to construct a metacopy overlayfs inode.
> 
> Maybe Vivek will be able to point you to the discussion that lead to making
> the features mutually exclusive.

I think I had not implemented metacopy with nfs export because it seemed
non-trivial and I did not need nfs export feature support with metacopy.
So I decided to narrow down the problem space and not support nfs
export and metacopy together.

It will be good if somebody can dive deeper and make it work (if it
is possible to make it work).

Vivek
> 
> I don't remember any other reason.
> 
> Thanks,
> Amir.
> 


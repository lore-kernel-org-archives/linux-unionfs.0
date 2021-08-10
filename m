Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BF3C4338F
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 20:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC57E60C3E
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Aug 2021 20:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhHJUAs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:00:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231671AbhHJUAs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Aug 2021 16:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628625621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hYFu3uhHvZqyDd2UHSQCO6uyK49mmLNls7fuYW/yHU=;
        b=Rhb6MGWY32mxNdyx222h+oH+3OLv1JYF81aFYU7pyPL+bCKOtIdf8b6pYuU/ldFx8AT4be
        C5ho9xS2uCppV157YxePEZ9bAMJ1HyyyKG3zcmTwa4fFGYkziU6OkNsfoFdvoT0MkqKUyi
        fDHs+3mnCeh9yjHooF0Q/5TF/uDMslM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-y_AaFKcVP2u3IWTHJm1hmw-1; Tue, 10 Aug 2021 16:00:20 -0400
X-MC-Unique: y_AaFKcVP2u3IWTHJm1hmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64BBF106F6EA;
        Tue, 10 Aug 2021 20:00:18 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.9.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185C217D4E;
        Tue, 10 Aug 2021 20:00:18 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A177D2237F5; Tue, 10 Aug 2021 16:00:17 -0400 (EDT)
Date:   Tue, 10 Aug 2021 16:00:17 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Nalin Dahyabhai <nalin@redhat.com>
Subject: Re: [QUESTION] Why overlayfs cannot mounted as nfs_export and
 metacopy?
Message-ID: <YRLa0f2Px63oCetX@redhat.com>
References: <ec78de1b-4edb-1eea-5c0d-79e65f139d79@huawei.com>
 <CAOQ4uxiO7zt7sywNqyd-WwCVds9-NqRAixham9yVeN7F+JhXoA@mail.gmail.com>
 <CAOQ4uxhAGSPKx6xsa5w_Wn9sax8LQQ=dPhB7Dtn1XDwghNpgvg@mail.gmail.com>
 <YRGfmx+xXVvERhhx@redhat.com>
 <CAOQ4uxhih4z=0xtuN4X11DY1xdhzsaQRDrtwuWFP2bejc41dWA@mail.gmail.com>
 <YRLYJ4uXLNR7NSmi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLYJ4uXLNR7NSmi@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:48:55PM -0400, Vivek Goyal wrote:

[..]
> > But beyond the complexity, what is the benefit?
> > I was under the impression that container manager do not know how
> > to build images with metacopy, so what are the chances of actually
> > seeing metacopy in middle layers in the wild?
> 
> Sure, we don't put metacopy inodes into portable images. But I thougt
> this could be part of a lower directory on same system. For example,
> docker devicemapper driver used to take an image and explode that
> on a thin volume. Then it will take a snaphost, modify some files
> and prefix that intermediate state with "-init". And then containers
> will use this "-init" as base for container rootfs and take snapshot
> of this.
> 
> I am not sure if container managers are doing this for overlayfs
> or not on same system. But I will not be surprised if somebody
> decides to do that. That's is change some metadata in image
> (which triggers metacopy) and then use upper layer as lower layer
> for container rootfs.
> 

In the past we were experimenting with chowning all files in image
according to user namespace of container using metacopy and use chowned
dir as lower layer for container rootfs. Ofcourse now, idmapped mounts
are available (not sure if it works with overlayfs yet or not) so chowning
images should not be required.

But point I am trying to make it is that I will not be surprised
that somebody comes up with use case of metacopy inode in lower
layer. So will be nice we take care of that configuration as well
while enabling metacopy with nfs_export (and deal with extra
complexity).

Vivek


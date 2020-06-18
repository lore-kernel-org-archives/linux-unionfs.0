Return-Path: <SRS0=SU5x=77=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAF3C433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 22:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD255207D8
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 22:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ek+RWjO5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgFRWGP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 18:06:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55493 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731651AbgFRWGP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jun 2020 18:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592517974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BBLG0ENQv8enbOp7iI3OK4LOhePTJS6NYhF5PdXKEJM=;
        b=ek+RWjO54weESNgx6SK+vSWkVCQiaedp8sg6kGvKkYMSapgG4038rt7tl+VBUA2tvnsESn
        eOKaKzPuWKA4lICyD8r1WrGbNUiQoADZPKylwFSgu5Cu5vO7OspwmQFlx/7SfDyxDkTh+z
        jT8+QRxbSWAcA42QJ5hNT+qKzr2wzno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-qrhMW6n5N-eETl3_6fU70g-1; Thu, 18 Jun 2020 18:06:12 -0400
X-MC-Unique: qrhMW6n5N-eETl3_6fU70g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80854107ACCA;
        Thu, 18 Jun 2020 22:06:11 +0000 (UTC)
Received: from horse.redhat.com (ovpn-112-177.rdu2.redhat.com [10.10.112.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6485E5EE0E;
        Thu, 18 Jun 2020 22:06:10 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id EBE85222D7B; Thu, 18 Jun 2020 18:06:09 -0400 (EDT)
Date:   Thu, 18 Jun 2020 18:06:09 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [ANNOUNCE] unionmount-testsuite: master branch updated to 9c60a9c
Message-ID: <20200618220609.GA3942@redhat.com>
References: <20200529164058.4654-1-amir73il@gmail.com>
 <20200618213831.GF3814@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618213831.GF3814@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 18, 2020 at 05:38:31PM -0400, Vivek Goyal wrote:

[..]
> 
> # ./run --ov --verify
> Environment variables:
> UNIONMOUNT_BASEDIR=/mnt/overlayfs/
> 
> ***
> *** ./run --ov --samefs --ts=0 open-plain
> ***
> TEST open-plain.py:10: Open O_RDONLY
> /mnt/overlayfs/m/a/foo100: not on union mount
> 
> Will spend more time to figure out what happened.

Ok, this is an issue only if I specify UNIONMOUNT_BASEDIR. If I don't,
then it passes.

Thanks
Vivek


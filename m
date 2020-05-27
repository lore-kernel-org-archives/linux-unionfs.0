Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FCFC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 18:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBB52073B
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 18:57:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eHnBr/EA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgE0S5F (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 14:57:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20116 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725747AbgE0S5F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 14:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590605824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieC/zpl8tK7LojFQ/GJsxuQqwcUE1eYBHVfKPes4nBk=;
        b=eHnBr/EAmgejGcUyvb2f8gUjuf819/JfTOpBRrYOmw3OWPB4uC+5Orl66W6oCzSxrtC28Y
        om/Y3wj+kK7L8ugXzkc0nwKzXwCRFsiqkqRav5yGi+a4xO4zOI+IC9XOdtJGZb3luX/pcY
        35oml0v83psyyoaXpUZXSQ9hXVj1/UY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-F4Bc2KJ0MpCNw701w21TCA-1; Wed, 27 May 2020 14:57:02 -0400
X-MC-Unique: F4Bc2KJ0MpCNw701w21TCA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A402107ACF2;
        Wed, 27 May 2020 18:57:01 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-83.rdu2.redhat.com [10.10.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC24E5D9E5;
        Wed, 27 May 2020 18:57:00 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 64BE2220391; Wed, 27 May 2020 14:57:00 -0400 (EDT)
Date:   Wed, 27 May 2020 14:57:00 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200527185700.GC140950@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 02:16:00PM +0300, Amir Goldstein wrote:

[..]
> That would be consistent with ovl_obtain_alias() which sets the
> OVL_UPPERDATA inode flag after getting the inode.

BTW, Is setting of OVL_UPPERDATA in ovl_obtain_alias() redundant as of
now, given ovl_get_inode() is already setting it.

Vivek


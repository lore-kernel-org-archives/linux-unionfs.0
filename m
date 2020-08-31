Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFE2C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CB50206CD
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X4mXex9D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHaQMi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:12:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726249AbgHaQMh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 12:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598890356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PlQgq6df5LkS0KA+SIh3nmrvVVKjELZ8IwKsBme/kww=;
        b=X4mXex9D/oiU2pJCjuBb89+uoaDnwZaTE+1zqknbQSs56jParhxf2SCb1FqyPX776Kx4AM
        8XC94cUxhsX71wC4+wA+/Qiw5PayzVEaFtCrpgRwiRPimw/4RHntM9vwEOOaKDf/M7afyT
        4KguzZQxsyjp+162W/TPYWtf9DKFi1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-So7NwXz0MXqN8tgsWth6iA-1; Mon, 31 Aug 2020 12:12:32 -0400
X-MC-Unique: So7NwXz0MXqN8tgsWth6iA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 793ED425E5;
        Mon, 31 Aug 2020 16:12:31 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-174.rdu2.redhat.com [10.10.114.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 817E97DA33;
        Mon, 31 Aug 2020 16:12:30 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 1458B220AD7; Mon, 31 Aug 2020 12:12:30 -0400 (EDT)
Date:   Mon, 31 Aug 2020 12:12:30 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2] ovl: check for incomapt features in work dir
Message-ID: <20200831161230.GB1172775@redhat.com>
References: <20200830202803.25028-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830202803.25028-1-amir73il@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:28:03PM +0300, Amir Goldstein wrote:

[..]
> @@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
>  				continue;
>  			if (p->len == 2 && p->name[1] == '.')
>  				continue;
> +		} else if (incompat) {
> +			pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> +				p->len, p->name);
> +			err = -EEXIST;
> +			break;

Hi Amir,

Should above be pr_err() instead of pr_warn()?

Apart from above minor nit, this patch looks good to me. I did a quick
test and it works.

Vivek


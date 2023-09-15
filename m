Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C9EEE6420
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 Sep 2023 06:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjIOGv6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 Sep 2023 02:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjIOGv5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2023 02:51:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB802722
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Sep 2023 23:51:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 306E21F74B;
        Fri, 15 Sep 2023 06:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1694760707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6d7Aexwx4MHakC44s5oI4XvpxKE+4R880qYFT7U8+nI=;
        b=D1lpx8QyS9VGuHz5xk0VhOY9UZMuOo5FH3p1OD5+Sp2rOIr1oLdaAaYZ3THLxVYSWsgukB
        HWAPZNEFliln2m1jAXFi4tPGpEGqXrpVeOeY3/U/ueg6xQOzBv+7DbZPMv7JqpHFQvI/7Y
        /dWjT9mOXaFVWSmGoIzGOXupuwK5yUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1694760707;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6d7Aexwx4MHakC44s5oI4XvpxKE+4R880qYFT7U8+nI=;
        b=ozzcvfkaT9lBnYhsOLHRUj2cfw8gw5RxnQ3l5upFxlRYHgxNAVG+q0ZoNlSxWNjkeWwxlw
        4kpupUh5zQrGKvBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D3D491358A;
        Fri, 15 Sep 2023 06:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aeITMgL/A2WcCQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 15 Sep 2023 06:51:46 +0000
Date:   Fri, 15 Sep 2023 08:51:45 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     rpalethorpe@suse.de, Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH 1/3] fanotify13: Test watching overlayfs upper fs
Message-ID: <20230915065145.GA15133@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20230903111558.2603332-1-amir73il@gmail.com>
 <20230903111558.2603332-2-amir73il@gmail.com>
 <87il8dghw0.fsf@suse.de>
 <CAOQ4uxhM8F6iyp5AVLquaq=NoR_V_6Y6NUjBDjqfjgcPvA5-Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhM8F6iyp5AVLquaq=NoR_V_6Y6NUjBDjqfjgcPvA5-Dw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir, Richie,

> On Thu, Sep 14, 2023 at 1:37 PM Richard Palethorpe <rpalethorpe@suse.de> wrote:

> > Hello Amir,

> > Amir Goldstein <amir73il@gmail.com> writes:

> > > Run a test variant with overlayfs (over all supported fs)
> > > when watching the upper fs.

> > > This is a regression test for kernel fix bc2473c90fca
> > > ("ovl: enable fsnotify events on underlying real files"),
> > > from kernel 6.5, which is not likely to be backported to older kernels.

> > > To avoid waiting for events that won't arrive when testing old kernels,
> > > require that kernel supports encoding fid with new flag AT_HADNLE_FID,
> > > also merged to 6.5 and not likely to be backported to older kernels.

> > Unfortunately Petr's not here at the moment.

> > I guess this first patch doesn't require 6.6? So it could be merged
> > independently without further considerations for what makes it into 6.6?


> Yes that is correct.

I'm finally back :).

Reviewed-by: Petr Vorel <pvorel@suse.cz>

I'll ask Cyril this patch to be merged before LTP release (final day today
before git freeze).

Kind regards,
Petr

> Thanks,
> Amir.

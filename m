Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7583CEDE9A3
	for <linux-unionfs@archiver.kernel.org>; Thu, 14 Sep 2023 10:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237318AbjINKho (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 06:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbjINKho (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Sep 2023 06:37:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32AA1BFE
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Sep 2023 03:37:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1608B21850;
        Thu, 14 Sep 2023 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694687858;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NRgjrYGmkY59tj7Cv2Cf74jHstl3bPUsvrK87M43cQ=;
        b=kSnc0AfUxhaY65jJsW2dN5rm8wlyMugrG/b1ByP/XAe/Oho3LS7PkkB6L10Ez5K74BihF1
        8XGbKsahGtn0vzMx7uU8TuJBSymsHHlu1gLfLvDJBp6ja5Moizp7CXbYPeXccuEkpOmy3V
        xtOQR0h7H0+eM6uESZtHLzlclOWqssM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694687858;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NRgjrYGmkY59tj7Cv2Cf74jHstl3bPUsvrK87M43cQ=;
        b=iuq3pdcszS7uQ1U4E4/RlkgskhdiufhuUIj9K6IqA1Jh1oqZuOJG7QsI+7Cg3dkBjavsRE
        icn7D2u+KqJXG6Cw==
Received: from g78 (rpalethorpe.tcp.ovpn1.nue.suse.de [10.163.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8BB612C142;
        Thu, 14 Sep 2023 10:37:37 +0000 (UTC)
References: <20230903111558.2603332-1-amir73il@gmail.com>
 <20230903111558.2603332-2-amir73il@gmail.com>
User-agent: mu4e 1.10.7; emacs 29.1
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Petr Vorel <pvorel@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH 1/3] fanotify13: Test watching overlayfs upper fs
Date:   Thu, 14 Sep 2023 11:32:39 +0100
Organization: Linux Private Site
Reply-To: rpalethorpe@suse.de
In-reply-to: <20230903111558.2603332-2-amir73il@gmail.com>
Message-ID: <87il8dghw0.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello Amir,

Amir Goldstein <amir73il@gmail.com> writes:

> Run a test variant with overlayfs (over all supported fs)
> when watching the upper fs.
>
> This is a regression test for kernel fix bc2473c90fca
> ("ovl: enable fsnotify events on underlying real files"),
> from kernel 6.5, which is not likely to be backported to older kernels.
>
> To avoid waiting for events that won't arrive when testing old kernels,
> require that kernel supports encoding fid with new flag AT_HADNLE_FID,
> also merged to 6.5 and not likely to be backported to older kernels.

Unfortunately Petr's not here at the moment.

I guess this first patch doesn't require 6.6? So it could be merged
independently without further considerations for what makes it into 6.6?

-- 
Thank you,
Richard.
